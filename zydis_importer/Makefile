all: parse generate merge verify

inc_dirs  = -I${ZYDIS_DIR}
inc_dirs += -I${ZYDIS_DIR}/include
inc_dirs += -I${ZYDIS_DIR}/dependencies/zycore/include/
inc_dirs += -I${ZYDIS_DIR}/include/Zydis

flags = -Wall -Wextra -pedantic -O3

parse:
	@ echo -n "Parsing zydis flags... "
	@ perl parse_zydis_flags.pl ${ZYDIS_DIR}/src/Generated/InstructionDefinitions.inc
	@ printf "done\n\n"

generate: generate_flag_accesses.cpp
	@ echo -n "Building generator... "
	@ g++ $(inc_dirs) $(flags) generate_flag_accesses.cpp -o generate_flag_accesses
	@ ./generate_flag_accesses >flag_accesses.out
	@ printf "done\n\n"

merge:
	@ for type in '' '_reduce'; do                                    \
			old="../arch/X86/X86MappingInsnOp$${type}.inc";               \
			new="X86MappingInsnOp$${type}.inc.new";                       \
			echo -n "Merging in zydis for '$${old}'... ";                 \
			perl merge_zydis_flags.pl flag_accesses.out $${old} >$${new}; \
			printf "done\n\n";                                            \
		done

verify:
	@ for type in '' '_reduce'; do                      \
			old="../arch/X86/X86MappingInsnOp$${type}.inc"; \
			new="X86MappingInsnOp$${type}.inc.new";         \
			echo "Verifying merge... ";                     \
			perl check_diff.pl $${old} $${new};             \
			echo;                                           \
		done

clean:
	@ rm -f X86MappingInsnOp.inc.new X86MappingInsnOp_reduce.inc.new
	@ rm -f flag_indices.inc generate_flag_accesses zydis_flags.inc

install:
	@ for type in '' '_reduce'; do                      \
			old="../arch/X86/X86MappingInsnOp$${type}.inc"; \
			new="X86MappingInsnOp$${type}.inc.new";         \
			mv $${new} $${old};                           \
		done
