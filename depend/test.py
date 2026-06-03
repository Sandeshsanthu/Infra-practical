import json
import sys
def main():
    try:
        input_data = json.loads(sys.stdin.read())
        environment = input_data.get("env", "dev")
        legacy_api_response = {
            "dev": {
                "legacy_project_id": "9942",
                "network_vlan": "vlan-100",
                "cost_center": "cc-research-4"
            },
            "prod": {
                "legacy_project_id": "1105",
                "network_vlan": "vlan-900",
                "cost_center": "cc-finance-1"
            }
        }
        result = legacy_api_response.get(environment, legacy_api_response["dev"])
        print(json.dumps(result))
    except Exception as e:
        print(json.dumps({"error": str(e)}), file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()

        
