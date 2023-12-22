.PHONY: setup setup-first-time dev envfile git-precommit-check
.PHONY: lint lint-rubocop test test-coverage test-lint lint-test

setup:
	bundle install --jobs 4 --retry 3
	yarn install
	bundle exec rails db:create db:migrate assets:precompile

setup-first-time:
	bundle install --jobs 4 --retry 3
	yarn install
	env DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:drop db:create db:migrate db:seed assets:precompile

dev:
	bin/dev

envfile:
	test -f .env || cp .env.example .env

lint: lint-rubocop

lint-i18n:
	bundle exec i18n-tasks health

lint-rubocop:
	bundle exec rubocop

lint-rubocop-fix:
	bundle exec rubocop -a

lint-rubocop-fiX:
	bundle exec rubocop -A

test:
	bundle exec rake test

test-coverage:
	COVERAGE=1 bundle exec rake test

lint-test: lint test
test-lint: test lint

git-precommit-check: setup test lint
