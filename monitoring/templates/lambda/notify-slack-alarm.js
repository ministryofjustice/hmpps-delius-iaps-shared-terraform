var https = require('https');
var util = require('util');

function sleep(milliseconds) {
  const date = Date.now();
  let currentDate = null;
  do {
    currentDate = Date.now();
  } while (currentDate - date < milliseconds);
}

exports.handler = function(event, context) {
    console.log(JSON.stringify(event, null, 2));

    const now = new Date(new Date().toLocaleString([], {timeZone: "Europe/London"})).getHours();
    const quietStart = +process.env.QUIET_PERIOD_START_HOUR, quietEnd = +process.env.QUIET_PERIOD_END_HOUR;
    const inQuietPeriod =
        quietStart <= quietEnd && (now >= quietStart && now < quietEnd) ||
        quietStart >  quietEnd && (now >= quietStart || now < quietEnd); // account for overnight periods (eg. 23:00-06:00)

    console.log("Alarms enabled:", process.env.ENABLED, ". Current hour:", now);
    if (process.env.ENABLED !== "true" || inQuietPeriod) { console.log("Dismissing notification."); return }

var eventMessage = JSON.parse(event.Records[0].Sns.Message);
var alarmName = eventMessage.AlarmName;
var alarmDescription = eventMessage.AlarmDescription;
var newStateValue = eventMessage.NewStateValue;

var environment = '${environment_name}';
var metric = alarmName.split("--")[0];
var severity = alarmName.split("--")[1];
var channel="${slack_channel}";
var url_path = "${slack_url}";
var icon_emoji=":twisted_rightwards_arrows:";

switch(severity) {
    case 'alert':
        icon_emoji = ":warning:";
        break;
    case 'critical':
        icon_emoji = ":alert:";
        break;
    case 'severe':
        icon_emoji = ":x:";
        break;
    case 'OK':
        icon_emoji = ":white_check_mark:";
        newStateValue='OK';
        sleep(2000);
        break;
    default:
        break;
    }

if (newStateValue=='OK' )
    icon_emoji = ":white_check_mark:";

if (newStateValue === "INSUFFICIENT_DATA" || (newStateValue === "OK" && eventMessage.OldStateValue === "INSUFFICIENT_DATA")) {
    console.log("Ignoring 'INSUFFICIENT_DATA' notification");
    return;
}

let textMessage = icon_emoji + " " + (severity === "ok"? "*RESOLVED*": "*ALARM*")
    + "\n> Severity: " + severity
    + "\n> Environment: " + environment
    + "\n> Description: *IAPS - " + eventMessage.AlarmDescription + "*"
    + "\n  <https://eu-west-2.console.aws.amazon.com/cloudwatch/home?region=eu-west-2#alarmsV2:alarm/"   + eventMessage.AlarmName + "|View Alarm Details>" 
    + " <https://eu-west-2.console.aws.amazon.com/cloudwatch/home?region=eu-west-2#logsV2:log-groups" + "| View Cloudwatch Logs>";
console.log(textMessage);

 //environment	service	    tier	metric	severity	resolvergroup(s)
console.log("Slack channel: " + channel);

if (newStateValue=='ALARM' )
    var postData = {
            "channel": "# " + channel,
            "username": "AWS SNS via Lambda :: Alarm Notification",
            "text": "**************************************************************************************************"
            + "\n\nInfo: " + alarmDescription
            + "\nAlarmState: " + newStateValue
            +"\nMetric: " + metric
            + "\nSeverity: " + severity.toUpperCase()
            + "\nEnvironment: " + environment
            ,
            "icon_emoji": icon_emoji,
            "link_names": "1"
        };

if (newStateValue=='OK' )
    var postData = {
            "channel": "# " + channel,
            "username": "AWS SNS via Lambda :: OK Notification",
            "text": textMessage,
            "icon_emoji": icon_emoji,
            "link_names": "1"
        };

    var options = {
        method: 'POST',
        hostname: 'hooks.slack.com',
        port: 443,
        path: url_path
    };

    var req = https.request(options, function(res) {
      res.setEncoding('utf8');
      res.on('data', function (chunk) {
        context.done(null);
      });
    });

    req.on('error', function(e) {
      console.log('problem with request: ' + e.message);
    });

    req.write(util.format("%j", postData));
    req.end();
};