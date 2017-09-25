ENV['AWS_PROFILE'] = ENV['AWS_DEFAULT_PROFILE']

Dir.chdir('terraform') {
	system('terraform get') or raise 'Terraform get failed'
	system('terraform apply') or raise 'Terraform apply failed'
	$terraform_output = JSON.parse(`terraform output --json`)
}
