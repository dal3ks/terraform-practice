1. [DONE]Understand the RDS resource and which necessary resources we need
2. [DONE]Create a module with the standard structure
3. [DONE]Implement variable validation
4. Implement networking validation
    4.1[DONE] Receive subnet IDs and security group IDs via variables
    4.2 [DONE]For subnets:
        4.2.1[DONE] Make sure that they are not in the default VPC
        4.2.2 [DONE]Make sure they are private:
            4.2.2.1 [DONE] Check whether they are tagged with Access=Private
    4.3 [DONE] For Security groups:
        4.3.1[DONE] Make sure that there are no inbound rules for IP addresses
5. [DONE] Create the necessary resources and ensure validation is working
6. [DONE] Create the RDS instance inside of the module