def lambda_handler(event, context):
    foo = event['foo']
    bar = event['bar']      
    result = my_lambda_function(foo, bar)

def my_lambda_function(foo, bar):
    // MyLambdaFunction logic here
