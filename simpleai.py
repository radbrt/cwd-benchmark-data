#%%
import openai
from dotenv import load_dotenv
import os
#%%

load_dotenv(".env")
openai.api_key = os.getenv("OPENAI_API_KEY")

#%%

rdf_content = open("ACME_Insurance/ontology/insurance.ttl", "r").read()

print(rdf_content[0:100])
# %%

ddl_content = open("ACME_Insurance/DDL/ACME_small.ddl", "r").read()

#%%

print(ddl_content[0:100])
# %%

question = "What are all the premiums that have been paid by policy holders?"


Q_TEMPLATE = f"""
Given the database described by the following DDL:
{ddl_content}
Write a SQL query that answers the following question. Do not explain the query. return just the query, so it can be run
verbatim from your response.
Here’s the question:
{question}
"""
# %%

import openai

print(openai.__version__)
#%%
client = openai.OpenAI()


#%%
client = openai.OpenAI(
    # defaults to os.environ.get("OPENAI_API_KEY")
    api_key=os.getenv("OPENAI_API_KEY"),
)

chat_completion = client.chat.completions.create(
    messages=[
        {
            "role": "user",
            "content": "Say this is a test",
        }
    ],
    model="gpt-3.5-turbo",
)
# %%
chat_completion
# %%
chat_completion.choices[0].message.content
# %%


def get_query(question, ddl_content):
    Q_TEMPLATE = f"""
    Given the database described by the following DDL:
    {ddl_content}
    Write a SQL query that answers the following question. Do not explain the query. return just the query, so it can be run
    verbatim from your response.
    Here’s the question:
    {question}
    """

    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": Q_TEMPLATE,
            }
        ],
        model="gpt-4-1106-preview",
    )
    return chat_completion.choices[0].message.content
# %%

question = "What are all the premiums that have been paid by policy holders?"

r = get_query(question, ddl_content)
# %%


print(r)
#%%

q2 = "Return all the policies and their policy holder by id"
r2 = get_query(q2, ddl_content)

print(r2)

# %%


def get_query_with_kg(question, ddl_content, rdf_content):
    Q_TEMPLATE = f"""
      Given the OWL model described in the following TTL file:
      {rdf_content}
      Write a SPARQL query that answers the question. The data for your query is available in a SERVICE identified by
      <mapped>. Do not explain the query. return just the query, so it can be run verbatim from your response.
      Here is the question:
      {question}
    """

    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "user",
                "content": Q_TEMPLATE,
            }
        ],
        model="gpt-4-1106-preview",
    )
    return chat_completion.choices[0].message.content
# %%
r = get_query_with_kg(question, ddl_content, rdf_content)
# %%

print(r)

#%%

r = get_query(question, ddl_content)
# %%

print(r)
# %%

question = "What is the loss ratio, number of claims, total loss by policy number and premium where total loss is the sum of loss payment, loss reserve, expense payment, expense reserve amount and loss ratio is total loss divided by premium?"


r = get_query_with_kg(question, ddl_content, rdf_content)
# %%

print(r)
# %%

r = get_query(question, ddl_content)

# %%

print(r)
# %%

