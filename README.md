# Bedside iOS app

Bedside iOS uses the AWS Amplify framework for connecting to the AWS backend.

# WARNING

Do not change code in the amplify/ folder. This should only be changed in the web project. Changes there can be pulled into this project using

`amplify pull`

Note:  You should run the above command every time you are working towards a new release.  Not doing so could mean your backend is out of sync with the current backend (admin web site project).  

# Codegen
`amplify codegen statements`
`amplify codegen types`

Note:  Regenerating types could lead to issues in the application, as these files have gotten far out of sync.  Run the codegen types statement at your own risk, and plan to make updates to the application in order to bring it back into working order.

# Preparing a release

## Prepare release candidate

After a build pointing to the dev branch has been ok'ed for release...

1. Merge develop into master.
2. Bump the build number by one.
3. Checkout the amplify prod environment using `amplify env checkout prod`
4. Build and run the app in the simulator. 
5. Test that you can log into a prod account & sanity check all features.
6. Archive and submit.
7. Sanity check on device. Get a second opinion.
8. Submit for review!

# Work-around for amplify pull failure.
 
1. Using the terminal, run the 'amplify pull' command
2. press ^ + C once that command get stuck.
3. From a finder window, Change the value of 'AmplifyAppId' to the valid app id in the 
    amplify/team-provider-info.json, 
    amplify/#current-cloud-backend/amplify-meta.json, and 
    amplify/backend/amplify-meta.json 
files.
4. Go back to the terminal and run 'amplify codegen models' command.

The 'amplify codegen models' command should be succeed.

