FROM quay.io/astronomer/astro-runtime:12.8.0

RUN python -m venv dbt_venv && source dbt_venv/bin/activate && \
    pip install --no-cache-dir dbt-bigquery==1.5.3 && pip install setuptools && deactivate