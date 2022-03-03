# Runs the bridge codegen script

message("Performing bridge codegen")

execute_process(COMMAND pwsh "scripts/gen.ps1" RESULT_VARIABLE CMD_ERROR OUTPUT_VARIABLE CMD_OUTPUT)

message("Codegen exit code: ${CMD_ERROR}")
message("Codegen output: ${CMD_OUTPUT}")

message("Done performing bridge codegen")
