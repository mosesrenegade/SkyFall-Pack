package Arguments

import (
	"WorkerMan/Packages/Converters"
	"WorkerMan/Packages/Manager"
	"WorkerMan/Packages/Output"
	"WorkerMan/Packages/Utils"
	"fmt"
	"log"
	"os"

	"github.com/spf13/cobra"
)

// buildArgument represents the 'build' command in the CLI.
var buildArgument = &cobra.Command{
	// Use defines how the command should be called.
	Use:          "build",
	Short:        "Generate and configure wrangler.json, index.js, and nginx's default site configuration",
	SilenceUsage: true,
	Aliases:      []string{"BUILD", "Build"},

	// RunE defines the function to run when the command is executed.
	RunE: func(cmd *cobra.Command, args []string) error {
		logger := log.New(os.Stderr, "[!] ", 0)

		// Show ASCII banner
		ShowAscii()

		// Check if additional arguments were provided
		if len(os.Args) <= 2 {
			err := cmd.Help()
			if err != nil {
				logger.Fatal("Error ", err)
				return err
			}
			os.Exit(0)
		}

		// Parse the arguments
		teamserver, _ := cmd.Flags().GetString("teamserver")
		worker, _ := cmd.Flags().GetString("worker")
		name, _ := cmd.Flags().GetString("name")
		port, _ := cmd.Flags().GetInt32("port")
		customHeader, _ := cmd.Flags().GetString("custom-header")
		customSecret, _ := cmd.Flags().GetString("custom-secret")

		// Call function named BuildManager
		teamserver, worker, name = Manager.BuildManager(teamserver, worker, name)

		// Call function named IntToString
		port2String := Converters.IntToString(int(port))

		// Call function named TemplateManager
		wranglerJson, indexJs := Manager.TemplateManager(teamserver, worker, name, port2String, customHeader, customSecret)

		// Call function named WriteOutput2File
		Output.WriteOutput2File(wranglerJson, "wrangler.json")

		// Call function named WriteOutput2File
		Output.WriteOutput2File(indexJs, "index.js")

		// Call function named GetAbsolutePath
		wranglerJsonPath, _ := Utils.GetAbsolutePath("wrangler.json")

		// Call function named GetAbsolutePath
		indexJsPath, _ := Utils.GetAbsolutePath("index.js")

		fmt.Printf("[+] wrangler.json file saved to: %s\n", wranglerJsonPath)
		fmt.Printf("[+] index.js file saved to: %s\n", indexJsPath)

		return nil
	},
}
