import * as cdk from "@aws-cdk/core";
import * as AmplifyHelpers from "@aws-amplify/cli-extensibility-helper";
import { AmplifyDependentResourcesAttributes } from "../../types/amplify-dependent-resources-ref";
import * as iam from "@aws-cdk/aws-iam";
import * as lambda from "@aws-cdk/aws-lambda";
import * as sns from "@aws-cdk/aws-sns";
import * as subs from "@aws-cdk/aws-sns-subscriptions";
import * as sqs from "@aws-cdk/aws-sqs";

export class cdkStack extends cdk.Stack {
  constructor(
    scope: cdk.Construct,
    id: string,
    props?: cdk.StackProps,
    amplifyResourceProps?: AmplifyHelpers.AmplifyResourceProps
  ) {
    super(scope, id, props);
    /* Do not remove - Amplify CLI automatically injects the current deployment environment in this input parameter */
    new cdk.CfnParameter(this, "env", {
      type: "String",
      description: "Current Amplify CLI env name",
    });
    /* AWS CDK code goes here - learn more: https://docs.aws.amazon.com/cdk/latest/guide/home.html */

    // Example 1: Set up an SQS queue with an SNS topic

    const amplifyProjectInfo = AmplifyHelpers.getProjectInfo();
    const sqsQueueResourceNamePrefix = `sqs-queue-${amplifyProjectInfo.projectName}`;
    const queue = new sqs.Queue(this, "sqs-queue", {
      queueName: `${sqsQueueResourceNamePrefix}-${cdk.Fn.ref("env")}`,
    });
    // 👇create sns topic

    const snsTopicResourceNamePrefix = `sns-topic-${amplifyProjectInfo.projectName}`;
    const topic = new sns.Topic(this, "sns-topic", {
      topicName: `${snsTopicResourceNamePrefix}-${cdk.Fn.ref("env")}`,
    });
    // 👇 subscribe queue to topic
    topic.addSubscription(new subs.SqsSubscription(queue));

    const dependencies : AmplifyDependentResourcesAttributes = AmplifyHelpers.addResourceDependency(this,
      amplifyResourceProps.category,
      amplifyResourceProps.resourceName,
      [{
        category: "function",
        resourceName: "applicationQueueDispatch"
      }]
    )

    const myFunctionArn = cdk.Fn.ref(dependencies.function.applicationQueueDispatch.Arn)
    topic.addSubscription(new subs.LambdaSubscription(lambda.Function.fromFunctionArn(this, "applicationQueueDispatchFn", myFunctionArn)))

    new cdk.CfnOutput(this, "snsTopicArn", {
      value: topic.topicArn,
      description: "The arn of the SNS topic",
    });
  }
}
