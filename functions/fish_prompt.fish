function _sksat_prompt_git -d 'print git information for prompt'
	set --local is_git_repo (command git rev-parse --is-inside-work-tree 2>/dev/null)
	set --local git_dirty_symbol (set_color brblack)'*'

	if test -n "$is_git_repo"
		__fish_git_prompt

		set --local is_git_dirty (
			not command git diff-index --ignore-submodules --cached --quiet HEAD -- >/dev/null 2>&1
			or not command git diff --ignore-submodules --no-ext-diff --quiet --exit-code >/dev/null 2>&1
			and echo "true"
		)

		if test -n "$is_git_dirty"
			echo $git_dirty_symbol
		end
	end
end

function _sksat_prompt_hostname
	echo (set_color cyan)(prompt_hostname)
end

function _sksat_prompt_pwd \
	--description 'print pwd for prompt' \
	--argument max_path_length

	set --local cur_dir (string replace $HOME '~' $PWD)

	if test -n "$max_path_length"
		if test (string length $cur_dir) -gt $max_path_length
			set cur_dir (prompt_pwd)
		end
	end
	echo (set_color blue)$cur_dir
end

function _sksat_print_prompt
	set --local prompt

	for p in $argv
		set --append prompt "$p"
	end

	echo (string trim -l $prompt)
end

function _sksat_prompt
	set --local host (_sksat_prompt_hostname)
	set --local dir (_sksat_prompt_pwd)
	set --local git_info (_sksat_prompt_git)

	echo (\
		_sksat_print_prompt \
		$dir \
		$git_info
	)
	echo (set_color red)"> "
end

function fish_prompt
	set --local exit_code $status
	set --local clear_line "\r\033[K"
	echo -e $clear_line

	_sksat_prompt
end

function fish_right_prompt
end
