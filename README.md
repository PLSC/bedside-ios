# Bedside iOS app

Bedside iOS uses the AWS Amplify framework for connecting to the AWS backend.

# WARNING
Do not change code in the amplify/ folder. This should only be changed in the web project. Changes there can be pulled into this project using

`amplify pull`

## Model generation
When changes occur to the main model definition in the web app, pull those changes into this environment and re-run model generation

```
amplify pull
amplify codegen models
```

After this you must move the models into the 'Models' group in Xcode.