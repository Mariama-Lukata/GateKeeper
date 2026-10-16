from aws_lambda_powertools import Logger, Metrics
from aws_lambda_powertools.metrics import MetricUnit

logger = Logger(service="gaterkeeper-deployment-gate")
metrics = Metrics(namespace="GaterKeeper", service="deployment-gate")


@logger.inject_lambda_context(log_event=True)
@metrics.log_metrics
def handler(event, context):
    try:
        logger.info("Processing deployment gate request")
        metrics.add_metric(name="InvocationCount", unit=MetricUnit.Count, value=1)

        return {"statusCode": 200, "body": "ok"}

    except Exception:
        logger.exception("Deployment gate request failed")
        metrics.add_metric(name="ErrorCount", unit=MetricUnit.Count, value=1)
        return {"statusCode": 500, "body": "internal error"}