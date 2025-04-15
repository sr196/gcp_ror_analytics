import functions_framework
from google.cloud import bigquery
from google.oauth2 import service_account

@functions_framework.http
def hello_http(request):
    """HTTP Cloud Function.
    Args:
        request (flask.Request): The request object.
        <https://flask.palletsprojects.com/en/1.1.x/api/#incoming-request-data>
    Returns:
        The response text, or any set of values that can be turned into a
        Response object using `make_response`
        <https://flask.palletsprojects.com/en/1.1.x/api/#flask.make_response>.
    """
    request_json = request.get_json(silent=True)
    request_args = request.args

    required_fields = set(['json_file_path', 'dataset_id', 'table_id'])
    
    if request_json and required_fields.issubset(set(request_json)):
        load_json_from_gcs_to_bigquery(gcs_uri=request_json['json_file_path'], dataset_id=request_json['dataset_id'], table_id=request_json['table_id'])
        
    elif request_args and required_fields.issubset(set(request_args)):
        load_json_from_gcs_to_bigquery(gcs_uri=request_args['json_file_path'], dataset_id=request_args['dataset_id'], table_id=request_args['table_id'])
    else:
        print("Invalid Request")
    return ""



def load_json_from_gcs_to_bigquery(gcs_uri, dataset_id, table_id):
    """
    Load a JSON file from a GCS bucket into a BigQuery table with all fields as STRING type.

    Args:
        gcs_uri (str): GCS URI of the JSON file (e.g., gs://bucket-name/file.json).
        dataset_id (str): BigQuery dataset ID.
        table_id (str): BigQuery table ID.

    Returns:
        None: Prints the number of rows loaded upon completion.
    """
    
    # Create a BigQuery client
    client = bigquery.Client()
    
    # Define the dataset and table references
    dataset_ref = client.dataset(dataset_id)
    table_ref = dataset_ref.table(table_id)
    
    # Configure the load job
    job_config = bigquery.LoadJobConfig()
    job_config.source_format = bigquery.SourceFormat.NEWLINE_DELIMITED_JSON
    
    job_config.autodetect = True
    
    # Load the JSON file from GCS into BigQuery
    load_job = client.load_table_from_uri(
        gcs_uri,
        table_ref,
        job_config=job_config
    )
    
    # Wait for the job to complete
    load_job.result()
    
    print(f"Loaded {load_job.output_rows} rows into {dataset_id}.{table_id}.")

