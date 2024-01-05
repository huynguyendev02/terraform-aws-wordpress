resource "aws_resourcegroups_group" "resg" {
  name = "resg-${var.project_name}"

  resource_query {
        query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::AllSupported"
  ],
  "TagFilters": [
    { 
      "Key": "CreatedBy",
      "Values": ["Terraform"]
    },
    { 
      "Key": "Project",
      "Values": ["${var.project_tag}"]
    },
    { 
      "Key": "Owner",
      "Values": ["${var.owner_tag}"]
    }
  ]
}
JSON
  }
  tags = {
    Name = "resg-${var.project_name}"
  }
}