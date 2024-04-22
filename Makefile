##
## EPITECH PROJECT, 2023
## Untitled (Workspace)
## File description:
## Makefile
##

BIN := ImgCompress-exe

NEW_BIN := imageCompressor

STACKDIR = $(shell stack path --local-install-root)

build: clean
	stack build
	cp $(STACKDIR)/bin/$(BIN) .
	mv $(BIN) $(NEW_BIN)

clean:

fclean: clean
	rm -f $(NEW_BIN)

re: fclean build

.PHONY: build clean fclean re
