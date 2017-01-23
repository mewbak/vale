#
# Main file for building Vale source code, under the src\tree
#

# Python imports
import os, os.path

# Imported identifiers defined in the SConstruct file
Import('env', 'BuildOptions', 'dafny_default_args', 'dafny_default_args_nonlarith')

#
# Verify *.vad and *.dfy under src/test/ and tools/vale/test/
#
verify_paths = [
  'src/test/',
  'tools/Vale/test'
]
Export('verify_paths')

#
# Table of special-case Dafny source which requires non-default arguments
#
verify_options = {
  'src/arch/arm/nlarith.s.dfy': BuildOptions(dafny_default_args),
  'src/arch/arm/bitvectors.i.dfy': BuildOptions(dafny_default_args_nonlarith + ' /proverOpt:OPTIMIZE_FOR_BV=true'),
  'src/crypto/aes/aes-x64/aes_main.i.dfy': BuildOptions(dafny_default_args_nonlarith + ' /compile:1'),
  'src/lib/math/mul_nonlinear.i.dfy': BuildOptions(dafny_default_args),
  'src/lib/math/div_nonlinear.i.dfy': BuildOptions(dafny_default_args),
  'src/crypto/hashing/sha-arm/bit-vector-lemmas.i.dfy': BuildOptions(dafny_default_args_nonlarith + ' /proverOpt:OPTIMIZE_FOR_BV=true'),
  'src/crypto/hashing/sha-x64/sha256_vale_main.i.dfy': BuildOptions(dafny_default_args_nonlarith + ' /compile:1'),
  'src/lib/math/div.i.dfy': BuildOptions(dafny_default_args_nonlarith + ' /timeLimit:60'),
  'src/lib/util/operations.i.dfy': BuildOptions(dafny_default_args_nonlarith + ' /proverOpt:OPTIMIZE_FOR_BV=true'),
  'obj/crypto/aes/cbc.gen.dfy': BuildOptions(dafny_default_args_nonlarith + ' /timeLimit:120'),

  # .dfy files default to this set of options
  '.dfy': BuildOptions(dafny_default_args_nonlarith),

  'tools/Vale/test/vale-debug.vad': None,

  # .vad files default to this set of options when compiling .gen.dfy
  '.vad': BuildOptions(dafny_default_args_nonlarith)

  # Disable verification by adding 'filename': None
}
if env['TARGET_ARCH']!='x86':
 verify_options['src/test/memcpy.vad'] = None
 verify_options['src/test/stack-test.vad'] = None
 
Export('verify_options')

#
# build sha256-exe
#
sha_asm = env.ExtractValeCode(
  ['src/crypto/hashing/$SHA_ARCH_DIR/sha256.vad'],           # Vale source
  'src/crypto/hashing/$SHA_ARCH_DIR/sha256_vale_main.i.dfy', # Dafny main
  'sha256'                                                   # Base name for the ASM files and EXE
  )
sha_c_h = env.ExtractDafnyCode(['src/crypto/hashing/sha256_main.i.dfy'])
sha_include_dir = os.path.split(str(sha_c_h[0][1]))[0]
env.BuildTest(['src/crypto/hashing/testsha256.c', sha_asm[0], sha_c_h[0][0]], sha_include_dir, 'testsha256')

#
# build cbc-exe
#
if env['TARGET_ARCH']=='x86':   # x86-only
  cbc_asm = env.ExtractValeCode(
    ['src/crypto/aes/aes.vad', 'src/crypto/aes/cbc.vad'],       # Vale source
    'src/crypto/aes/cbc_main.i.dfy',                            # Dafny main
    'cbc'                                                       # Base name for the ASM files and EXE
    )
  env.BuildTest(['src/crypto/aes/testcbc.c', cbc_asm[0]], '', 'testcbc')

#
# build aes-exe
#
aes_asm = env.ExtractValeCode(
  ['src/crypto/aes/$AES_ARCH_DIR/aes.vad'],        # Vale source
  'src/crypto/aes/$AES_ARCH_DIR/aes_main.i.dfy',   # Dafny main
  'aes'                                            # Base name for the ASM files and EXE
  )
env.BuildTest(['src/crypto/aes/testaes.c', aes_asm[0]], 'src/crypto/aes', 'testaes')