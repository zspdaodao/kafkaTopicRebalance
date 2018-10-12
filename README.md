# kafkaTopicRebalance
    Step 1

        编辑  what-needed.sh

        参数注意点：
        zkServer:需要操作的kafka集群的zookeeper地址.
        brokerList:希望将目标topic迁移到哪些 brokerList
        topicsToMoveFile:此项不用修改 用以从topics-to-move.json文件获取需要操作的topic信息
    Step 2

        编辑 topics-to-move.json 文件用以确认我们需要操作的 topic 信息

        注意点:
        1.key: topics 后的value 虽然为一个 array 但是,我们不建议一次配置多个,建议一次只配置一个topic,待完成后再操作下一个Topic
    Step 3 

        执行 rebalance-starter.sh 脚本文件

        脚本基本逻辑:
        1.通过以上配置生成一个expand-cluster-reassignment.json文件

        2. 记录日志至 save-for-roll-back.json
        3. 将生成的 expand-cluster-reassignment.json 文件以参数的形式传给 /bin/kafka-reassign-partitions 工具  expand-cluster-reassignment.json 基本格式如下:
                {"version":1,
                           "partitions":[{"topic":"foo1","partition":2,"replicas":[1,2]},
                                             {"topic":"foo1","partition":0,"replicas":[3,4]}]
                 }
    Step 4  

        check 是否迁移成功 执行: ../bin/kafka-reassign-partitions  --zookeeper $zkServer --reassignment-json-file expand-cluster-reassignment.json --verify 即可

        或者在 kafkaManger上查看操作的 topic 的 Partitions by Broker 信息

Attention:

                    1.Topic 要一个个迁移

                    2. 每次迁移完成后要确认是否迁移成功,成功再继续迁移下一个Topic

                    3. 每次迁移Topic 之前，需要停掉Topic对应的 producer 以降低风险
