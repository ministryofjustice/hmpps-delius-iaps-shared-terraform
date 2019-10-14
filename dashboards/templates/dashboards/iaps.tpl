{
    "widgets": [
        {
            "type": "metric",
            "x": 6,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "CWAgent", "Paging File % Usage", "instance", "\\??\\C:\\pagefile.sys", "AutoScalingGroupName", "${environment_name}-${project_name}-iaps-asg", "objectname", "Paging File", { "color": "#d62728" } ],
                    [ ".", "Memory % Committed Bytes In Use", "AutoScalingGroupName", "${environment_name}-${project_name}-iaps-asg", "objectname", "Memory", { "label": "Memory % Committed Bytes In Use", "color": "#2ca02c" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${region}",
                "title": "Mem Util",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "CWAgent", "PhysicalDisk % Disk Time", "instance", "0 C:", "AutoScalingGroupName", "${environment_name}-${project_name}-iaps-asg", "objectname", "PhysicalDisk" ],
                    [ ".", "LogicalDisk % Free Space", ".", "C:", ".", ".", ".", "LogicalDisk" ]
                ],
                "region": "${region}",
                "title": "Disk Util",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "CWAgent", "Processor % Idle Time", "instance", "_Total", "AutoScalingGroupName", "${environment_name}-${project_name}-iaps-asg", "objectname", "Processor", { "color": "#2ca02c", "stat": "Minimum", "period": 60 } ],
                    [ ".", "Processor % User Time", ".", ".", ".", ".", ".", ".", { "color": "#d62728", "stat": "Maximum", "period": 60 } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "${region}",
                "title": "CPU Util"
            }
        },
        {
            "type": "log",
            "x": 0,
            "y": 6,
            "width": 6,
            "height": 3,
            "properties": {
                "query": "SOURCE 'IAPS' | fields @timestamp, @message\n| sort @timestamp desc\n| filter @logStream like /i2n-daysummary.log/\n| filter @message like /ERROR/\n| stats count() by bin(1m)",
                "region": "${region}",
                "stacked": false,
                "title": "IAPS Log Errors",
                "view": "timeSeries"
            }
        },
        {
            "type": "log",
            "x": 6,
            "y": 6,
            "width": 6,
            "height": 3,
            "properties": {
                "query": "SOURCE 'IAPS' | fields @timestamp, @message\n| sort @timestamp desc\n| filter @logStream like /nginx-access-log/\n| stats count() by bin(1m)",
                "region": "${region}",
                "stacked": false,
                "title": "NGINX Access Log Events",
                "view": "timeSeries"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 9,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "tf-${region}-hmpps-${environment_name}-iaps" ],
                    [ ".", "CPUCreditUsage", ".", "." ],
                    [ ".", "BurstBalance", ".", "." ]
                ],
                "region": "${region}",
                "title": "RDS CPU Util"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 9,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", "tf-${region}-hmpps-${environment_name}-iaps" ]
                ],
                "region": "${region}",
                "title": "RDS DB Connxns"
            }
        },
        {
            "type": "log",
            "x": 18,
            "y": 6,
            "width": 6,
            "height": 3,
            "properties": {
                "query": "SOURCE 'IAPS' | fields @timestamp, @message\n| sort @timestamp desc\n| filter @logStream like /system-events/\n| stats count() by bin(1m)",
                "region": "${region}",
                "stacked": false,
                "title": "System Events (WARN, ERR< CRITICAL)",
                "view": "timeSeries"
            }
        },
        {
            "type": "log",
            "x": 12,
            "y": 6,
            "width": 6,
            "height": 3,
            "properties": {
                "query": "SOURCE 'IAPS' | fields @timestamp, @message\n| sort @timestamp desc\n| filter @logStream like /nginx-error-log/\n| stats count() by bin(1m)",
                "region": "${region}",
                "stacked": false,
                "title": "NGINX Error Log Events",
                "view": "timeSeries"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 9,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", "tf-${region}-hmpps-${environment_name}-iaps" ]
                ],
                "region": "${region}",
                "title": "RDS Mem Util"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 15,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", "tf-${region}-hmpps-${environment_name}-iaps" ]
                ],
                "region": "${region}",
                "title": "RDS Storage Util"
            }
        },
        {
            "type": "metric",
            "x": 0,
            "y": 15,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "ReadIOPS", "DBInstanceIdentifier", "tf-${region}-hmpps-${environment_name}-iaps" ],
                    [ ".", "ReadThroughput", ".", "." ]
                ],
                "region": "${region}",
                "title": "RDS Read Util"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 15,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "WriteThroughput", "DBInstanceIdentifier", "tf-${region}-hmpps-${environment_name}-iaps" ],
                    [ ".", "WriteIOPS", ".", "." ]
                ],
                "region": "${region}",
                "title": "RDS Write Util"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 15,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "NetworkReceiveThroughput", "DBInstanceIdentifier", "tf-${region}-hmpps-${environment_name}-iaps" ],
                    [ ".", "NetworkTransmitThroughput", ".", "." ]
                ],
                "region": "${region}",
                "title": "RDS Net Util"
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 9,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "CPUCreditBalance", "DBInstanceIdentifier", "tf-${region}-hmpps-${environment_name}-iaps" ],
                    [ ".", "CPUCreditUsage", ".", "." ]
                ],
                "region": "${region}",
                "title": "RDS CPU Credit Util"
            }
        },
        {
            "type": "metric",
            "x": 18,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/Logs", "IncomingLogEvents", "LogGroupName", "IAPS" ]
                ],
                "region": "${region}",
                "title": "Total Log Events"
            }
        }
    ]
}