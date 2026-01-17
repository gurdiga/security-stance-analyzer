.PHONY: install link uninstall test clean help

SKILL_NAME := security-stance-analyzer
INSTALL_DIR := $(HOME)/.config/claude/skills/$(SKILL_NAME)

help:
	@printf '%s\n' \
		'Security Stance Analyzer - Makefile' \
		'' \
		'Available targets:' \
		'  install     - Install skill to ~/.config/claude/skills/' \
		'  link        - Symlink skill for development' \
		'  uninstall   - Remove skill from ~/.config/claude/skills/' \
		'  test        - Run tests on scripts' \
		'  clean       - Remove temporary files' \
		'  help        - Show this help message'

install:
	@echo "Installing $(SKILL_NAME) to $(INSTALL_DIR)..."
	@mkdir -p $(INSTALL_DIR)/scripts $(INSTALL_DIR)/references
	@cp SKILL.md README.md LICENSE CHANGELOG.md $(INSTALL_DIR)/
	@cp scripts/*.sh $(INSTALL_DIR)/scripts/
	@chmod +x $(INSTALL_DIR)/scripts/*.sh
	@cp references/*.md $(INSTALL_DIR)/references/
	@printf '%s\n' \
		'✓ Installation complete!' \
		'' \
		"Skill installed to: $(INSTALL_DIR)" \
		"To verify, run: ls -la $(INSTALL_DIR)"

link:
	@echo "Creating symlink for $(SKILL_NAME)..."
	@mkdir -p $(HOME)/.config/claude/skills
	@ln -sf $(CURDIR) $(INSTALL_DIR)
	@printf '%s\n' \
		'✓ Symlink created!' \
		'' \
		"Skill linked to: $(INSTALL_DIR)" \
		"Changes in $(CURDIR) will be reflected immediately"

uninstall:
	@echo "Uninstalling $(SKILL_NAME) from $(INSTALL_DIR)..."
	@if [ -d "$(INSTALL_DIR)" ]; then \
		rm -rf $(INSTALL_DIR); \
		echo "✓ Uninstallation complete!"; \
	else \
		echo "Skill not found at $(INSTALL_DIR)"; \
	fi

test:
	@echo "Running tests..."
	@printf '%s\n' \
		'' \
		'Testing scan-secrets.sh...'
	@bash scripts/scan-secrets.sh . || true
	@printf '%s\n' \
		'' \
		'Testing check-dependencies.sh...'
	@bash scripts/check-dependencies.sh || true
	@printf '%s\n' \
		'' \
		'✓ Tests complete!'

clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.log" -o -name "npm-audit.json" -delete
	@rm -rf scan-results/
	@echo "✓ Clean complete!"
