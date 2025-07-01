import boto3
from openpyxl import Workbook

# Initialize the IAM client
iam_client = boto3.client('iam')

def get_roles_with_prefix(prefix):
    roles_with_prefix = []
    paginator = iam_client.get_paginator('list_roles')

    for page in paginator.paginate():
        for role in page['Roles']:
            role_name = role['RoleName']
            if role_name.lower().startswith(prefix.lower()):
                roles_with_prefix.append({
                    'RoleName': role_name,
                    'Arn': role['Arn'],
                    'CreateDate': role['CreateDate'].strftime('%Y-%m-%d %H:%M:%S')
                })
    
    return roles_with_prefix

def write_to_excel(roles, filename):
    wb = Workbook()
    ws = wb.active
    ws.title = "IAM Roles"

    # Header row
    ws.append(["RoleName", "Arn", "CreateDate"])

    # Data rows
    for role in roles:
        ws.append([role['RoleName'], role['Arn'], role['CreateDate']])

    wb.save(filename)

if __name__ == "__main__":
    prefix = "GitHubAction-AssumeRole"
    filename = "githubaction_roles.xlsx"

    print(f"Fetching IAM roles starting with prefix '{prefix}'...")
    matching_roles = get_roles_with_prefix(prefix)

    if matching_roles:
        print(f"Found {len(matching_roles)} roles. Writing to '{filename}'...")
        write_to_excel(matching_roles, filename)
        print("Done.")
    else:
        print(f"No IAM roles found with prefix '{prefix}'.")
