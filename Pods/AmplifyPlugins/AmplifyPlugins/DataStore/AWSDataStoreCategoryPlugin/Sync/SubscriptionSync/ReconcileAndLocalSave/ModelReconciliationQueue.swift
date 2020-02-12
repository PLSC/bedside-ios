//
// Copyright 2018-2019 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import AWSPluginsCore

@available(iOS 13.0, *)
protocol ModelReconciliationQueue {
    func start()
    func pause()
    func cancel()
    func enqueue(_ remoteModel: MutationSync<AnyModel>)

}
