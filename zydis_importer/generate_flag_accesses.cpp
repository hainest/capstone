#include <cstdint>
#include <iostream>
#include <vector>

#include "Zydis/Internal/SharedData.h"
#include "src/Generated/AccessedFlags.inc"

std::vector<std::uint64_t> cpu_flag_ids = {
  ZYDIS_CPUFLAG_CF, ZYDIS_CPUFLAG_PF, ZYDIS_CPUFLAG_AF, ZYDIS_CPUFLAG_ZF, ZYDIS_CPUFLAG_SF,
  ZYDIS_CPUFLAG_TF, ZYDIS_CPUFLAG_IF, ZYDIS_CPUFLAG_DF, ZYDIS_CPUFLAG_OF, ZYDIS_CPUFLAG_IOPL,
  ZYDIS_CPUFLAG_NT, ZYDIS_CPUFLAG_RF, ZYDIS_CPUFLAG_VM, ZYDIS_CPUFLAG_AC, ZYDIS_CPUFLAG_VIF,
  ZYDIS_CPUFLAG_VIP, ZYDIS_CPUFLAG_ID
};
std::vector<std::uint64_t> fpu_flag_ids = {
  ZYDIS_FPUFLAG_C0, ZYDIS_FPUFLAG_C1, ZYDIS_FPUFLAG_C2, ZYDIS_FPUFLAG_C3
};

struct insn_flag_index {
  char const* name;
  int index;
};

#include "flag_indices.inc"

char const* get_cpu_flag_name(std::uint64_t mask) {
  switch(mask) {
    case ZYDIS_CPUFLAG_CF: return "X86_EFLAGS_CF";
    case ZYDIS_CPUFLAG_PF: return "X86_EFLAGS_PF";
    case ZYDIS_CPUFLAG_AF: return "X86_EFLAGS_AF";
    case ZYDIS_CPUFLAG_ZF: return "X86_EFLAGS_ZF";
    case ZYDIS_CPUFLAG_SF: return "X86_EFLAGS_SF";
    case ZYDIS_CPUFLAG_TF: return "X86_EFLAGS_TF";
    case ZYDIS_CPUFLAG_IF: return "X86_EFLAGS_IF";
    case ZYDIS_CPUFLAG_DF: return "X86_EFLAGS_DF";
    case ZYDIS_CPUFLAG_OF: return "X86_EFLAGS_OF";
    case ZYDIS_CPUFLAG_IOPL: return "X86_EFLAGS_IOPL";
    case ZYDIS_CPUFLAG_NT: return "X86_EFLAGS_NT";
    case ZYDIS_CPUFLAG_RF: return "X86_EFLAGS_RF";
    case ZYDIS_CPUFLAG_VM: return "X86_EFLAGS_VM";
    case ZYDIS_CPUFLAG_AC: return "X86_EFLAGS_AC";
    case ZYDIS_CPUFLAG_VIF: return "X86_EFLAGS_VIF";
    case ZYDIS_CPUFLAG_VIP: return "X86_EFLAGS_VIP";
    case ZYDIS_CPUFLAG_ID: return "X86_EFLAGS_ID";
  };
  return "UNKNOWN";
}

char const* get_fpu_flag_name(std::uint64_t mask) {
  switch(mask) {
    case ZYDIS_FPUFLAG_C0: return "X86_FPUFLAGS_C0";
    case ZYDIS_FPUFLAG_C1: return "X86_FPUFLAGS_C1";
    case ZYDIS_FPUFLAG_C2: return "X86_FPUFLAGS_C2";
    case ZYDIS_FPUFLAG_C3: return "X86_FPUFLAGS_C3";
  };
  return "UNKNOWN";
}

std::vector<char const*> tested, modified, set_0, set_1, undefined;

void gather_flags(ZydisAccessedFlags const& flags, std::vector<std::uint64_t> ids, char const*(*get_flag_name)(std::uint64_t)) {
  tested.clear();
  modified.clear();
  set_0.clear();
  set_1.clear();
  undefined.clear();

  for(auto id : ids) {
    if(flags.tested & id) {
      tested.push_back(get_flag_name(id));
    }
    if(flags.modified & id) {
      modified.push_back(get_flag_name(id));
    }
    if(flags.set_0 & id) {
      set_0.push_back(get_flag_name(id));
    }
    if(flags.set_1 & id) {
      set_1.push_back(get_flag_name(id));
    }
    if(flags.undefined & id) {
      undefined.push_back(get_flag_name(id));
    }
  }
}

bool have_any() {
  return !tested.empty() ||!modified.empty() ||!set_0.empty() ||!set_1.empty() ||!undefined.empty();
}

void dump_flags() {

  auto dump = [](std::vector<char const*> const& names, char const* type) {
    std::cout << "\t\t\t";

    if(!names.empty()) {
      bool need_pipe = false;
      for(char const* n : names) {
        if(need_pipe) std::cout << " | ";
        std::cout << n;
        need_pipe = true;
      }
    } else {
      std::cout << "0";
    }

    std::cout << ", // " << type << "\n";
  };

  dump(tested, "tested");
  dump(modified, "modified");
  dump(set_0, "set_0");
  dump(set_1, "set_1");
  dump(undefined, "undefined");
}

int main() {
  for(auto const& idx: insn_flags) {
    std::cout << idx.name << "\n";

    std::cout << "\t{\n";

    auto const& cpu_flags = ACCESSED_FLAGS[idx.index].cpu_flags;
    gather_flags(cpu_flags, cpu_flag_ids, get_cpu_flag_name);
    if(have_any()) {
      std::cout << "\t\t{// CPU\n";
      dump_flags();
      std::cout << "\t\t},\n";
    } else {
      std::cout << "\t\t{}, // CPU\n";
    }

    auto const& fpu_flags = ACCESSED_FLAGS[idx.index].fpu_flags;
    gather_flags(fpu_flags, fpu_flag_ids, get_fpu_flag_name);
    if(have_any()) {
      std::cout << "\t\t{// FPU\n";
      dump_flags();
      std::cout << "\t\t},\n";
    } else {
      std::cout << "\t\t{}, // FPU\n";
    }

    std::cout << "\t}\n";

    std::cout << "ENDRECORD\n\n";
  }
}




