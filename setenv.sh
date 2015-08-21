#!/bin/bash
JSON=$(cat <<EOF
{
   "cloudantNoSQLDB": [
      {
         "name": "Cloudant NoSQL DB-fs",
         "label": "cloudantNoSQLDB",
         "plan": "Shared",
         "credentials": {
            "username": "d5583398-f811-4157-851c-46305cae3f8f-bluemix",
            "password": "239c170a3b8fbe66f3cfe777d41356eeee86c1ac21017e8874225dc3e668bba3",
            "host": "d5583398-f811-4157-851c-46305cae3f8f-bluemix.cloudant.com",
            "port": 443,
            "url": "https://d5583398-f811-4157-851c-46305cae3f8f-bluemix:239c170a3b8fbe66f3cfe777d41356eeee86c1ac21017e8874225dc3e668bba3@d5583398-f811-4157-851c-46305cae3f8f-bluemix.cloudant.com"
         }
      }
   ]
}
EOF
)

echo $JSON
export VCAP_SERVICES=$JSON
