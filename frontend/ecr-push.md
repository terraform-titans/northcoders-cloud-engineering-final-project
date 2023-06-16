`aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws`

`docker tag e9ae3c220b23 public.ecr.aws/registry_alias/my-web-app`

`docker push public.ecr.aws/registry_alias/my-web-app`