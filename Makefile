all:
	luacheck --std lua51 ./lua

test:
	nv --headless -c "PlenaryBustedDirectory tests/ { minimal_init = '/home/creativenull/.config/nvim-nightly/init.lua' }"
