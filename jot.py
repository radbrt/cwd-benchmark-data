#%%
t = "PREFIX : <https://myinsurancecompany.linked.data.world/d/chat-with-the-data-benchmark/>\nPREFIX in: <http://data.world/schema/insurance/>\n\nSELECT ?policynumber ?PolicyHolderID ?premium\nWHERE {\nSERVICE :mapped {\n    ?pcd a in:PolicyCoverageDetail;\n        in:hasPremiumAmount [ \n            in:premiumAmount ?premium;\n        ];\n        in:hasPolicy ?policy. \n\n     ?policy a in:Policy;\n            in:policyNumber ?policynumber;\n            in:hasPolicyHolder [ \n                in:policyHolderId ?PolicyHolderID \n            ];\n    .\n    }\n}\n"


print(t)
# %%


t = "select policy.policy_number, party_identifier, policy_amount\nfrom agreement_party_role\njoin policy on agreement_party_role.agreement_identifier = policy.policy_identifier\ninner join policy_amount on policy.policy_identifier = policy_amount.policy_identifier\ninner join premium on premium.policy_amount_identifier = policy_amount.policy_amount_identifier\nwhere agreement_party_role.party_role_code = 'PH'"

print(t)
# %%


## NEXT: Inserts

import glob

csvs = glob.glob("ACME_Insurance/data/*.csv")

print(csvs)
# %%
import os
import pandas as pd
from sqlalchemy import create_engine
from snowflake.sqlalchemy import URL
from dotenv import load_dotenv

load_dotenv(".env")

engine = create_engine(URL(
    account = os.environ["SNOWFLAKE_ACCOUNT"],
    user = os.environ["SNOWFLAKE_USER"],
    password = os.environ["SNOWFLAKE_PASSWORD"],
    database = os.environ["SNOWFLAKE_DATABASE"],
    schema = os.environ["SNOWFLAKE_SCHEMA"],
    warehouse = os.environ["SNOWFLAKE_WAREHOUSE"],
))

conn = engine.connect()

#%%
def insert_csv(filename, conn):
    with open(filename, "r") as f:
        basename = os.path.basename(filename)
        print(f"Inserting {basename}")
        df = pd.read_csv(f)
        print(df.head())

        df.to_sql(basename, engine, if_exists="append", index=False)
# %%


for csv in csvs:
    insert_csv(csv, conn)
# %%

from marvin import ai_fn
import marvin

marvin.settings.llm_model = 'openai/gpt-4-1106-preview'
#%%

@ai_fn
def make_statement(csv: str, table_name: str, ddl_statements: str) -> str:
    """
    Produce a SQL Insert statement using the schema from the DDL statement, and values from the CSV file.
    
    Compare the DDL statement with the headers of the SQL file to determine the order of the columns.
    If there are missing columns from the CSV, use the default value from the DDL statement or a sequence 
    starting with 1 and incrementing by 1 for NOT NULL columns.

    Make sure to name the columns in the INSERT statement.

    params:
        csv: The string content of the CSV file
        table_name: the name of the table to insert to
        ddl_statements: the DDL definitions for a number of tables
    """
# %%


ddls = open("ACME_Insurance/DDL/ACME_small.ddl", "r").read()

for csv in csvs:
    with open(csv, "r") as f:
        csv_content = f.read()
        print(make_statement(csv_content, os.path.basename(csv).split(".")[0], ddls))
# %%


