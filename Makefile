.PHONY: install uninstall test clean help

SKILL_NAME := security-stance-analyzer
INSTALL_DIR := $(HOME)/.config/claude/skills/$(SKILL_NAME)

help:
	@echo "Security Stance Analyzer - Makefile"
	@echo ""
	@echo "Available targets:"
	@echo "  install     - Install skill to ~/.config/claude/skills/"
	@echo "  uninstall   - Remove skill from ~/.config/claude/skills/"
	@echo "  test        - Run tests on scripts"
	@echo "  clean       - Remove temporary files"
	@echo "  help        - Show this help message"

install:
	@echo "Installing $(SKILL_NAME) to $(INSTALL_DIR)..."
	@mkdir -p $(INSTALL_DIR)
	@mkdir -p $(INSTALL_DIR)/scripts
	@mkdir -p $(INSTALL_DIR)/references
	@cp SKILL.md $(INSTALL_DIR)/
	@cp README.md $(INSTALL_DIR)/
	@cp LICENSE $(INSTALL_DIR)/
	@cp CHANGELOG.md $(INSTALL_DIR)/
	@cp scripts/*.sh $(INSTALL_DIR)/scripts/
	@chmod +x $(INSTALL_DIR)/scripts/*.sh
	@cp references/*.md $(INSTALL_DIR)/references/
	@echo "✓ Installation complete!"
	@echo ""
	@echo "Skill installed to: $(INSTALL_DIR)"
	@echo "To verify, run: ls -la $(INSTALL_DIR)"

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
	@echo ""
	@echo "Testing scan-secrets.sh..."
	@bash scripts/scan-secrets.sh . || true
	@echo ""
	@echo "Testing check-dependencies.sh..."
	@bash scripts/check-dependencies.sh || true
	@echo ""
	@echo "✓ Tests complete!"

clean:
	@echo "Cleaning temporary files..."
	@find . -name "*.log" -delete
	@find . -name "npm-audit.json" -delete
	@rm -rf scan-results/
	@echo "✓ Clean complete!"
