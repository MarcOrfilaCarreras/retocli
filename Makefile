build:
	@rm generate.sh.x.c 2> /dev/null || true
	@rm retocli 2> /dev/null || true

	@awk 1 bin/* retocli.sh > generate.sh
	@sed -i '/source.*/d' generate.sh
	@echo '#!/bin/bash' | cat - generate.sh > temp && mv temp generate.sh

	shc -f generate.sh -o retocli
	@rm generate.sh.x.c 2> /dev/null || true

clean:
	@rm generate.sh.x.c 2> /dev/null || true
	@rm generate.sh 2> /dev/null || true
	@rm retocli 2> /dev/null || true