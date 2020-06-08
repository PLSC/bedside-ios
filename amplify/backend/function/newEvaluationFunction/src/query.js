module.exports = {
  mutation: /* GraphQL */ `
    mutation CreateEvaluation(
      $input: CreateEvaluationInput!
      $condition: ModelEvaluationConditionInput
    ) {
      createEvaluation(input: $input, condition: $condition) {
        id
        subjectId
        raterId
        procedureId
        evaluationDate
        ratingLevel
      }
    }
  `,
};
