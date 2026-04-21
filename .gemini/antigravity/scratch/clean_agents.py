import os

input_file = r'c:\Users\pablo\dev_Projects\alfresco-73-1\new_project\gedfacil-alfresco\AGENTS.md'
output_file = r'c:\Users\pablo\dev_Projects\alfresco-73-1\new_project\gedfacil-alfresco\AGENTS_CLEAN.md'
separator = '| --------- | -------- | ------------- |'

with open(input_file, 'r', encoding='utf-8') as f:
    content = f.read()

cleaned_content = content.replace(separator, '')

with open(output_file, 'w', encoding='utf-8') as f:
    f.write(cleaned_content)

print(f"Cleaned file written to {output_file}")
print(f"Original size: {len(content)}")
print(f"Cleaned size: {len(cleaned_content)}")
