
// An optimized build (jai first.jai -o): its LLVM optimization isn't O0.
RELEASE :: #run get_build_options().llvm_options.bitcode_optimization_setting != .O0;
main_filepath :: "src/main.jai";
exe_icon_path :: "../assets/bunny.ico";

#run build();
build :: () {

  // seperate build options for debug vs release
  build_options((options: *Build_Options) {
    options.output_executable_name = "bunnymark";

    #if !RELEASE then options.backend = .X64;
    #if  RELEASE then #run Windows_Resources.disable_runtime_console();
    // (an optimized build keeps its debug information, a .pdb, so a profile's
    // report can name its procedures and lines)
  });

  // wait for the exe to finish compiling, so we can set its icon
  build_compile(main_filepath);

  // set exe icon
  exe_path := tprint("%1%2.exe", options.output_path, options.output_executable_name);
  Windows_Resources.set_icon_by_filename(exe_path, exe_icon_path);
}



#import "Basic";
#import "Compiler";
Windows_Resources :: #import "Windows_Resources";

w: Workspace;
options: Build_Options;
build_inited := false;
build_ensure_init :: () {
  if build_inited return; build_inited = true;
  w       = compiler_create_workspace();
  options = get_build_options();
  set_build_options_dc(.{do_output=false});
}
build_options :: (fn: (*Build_Options)) {
  build_ensure_init();
  fn(*options);
  set_build_options(options, w);
}
build_compile :: (src_files: ..string) {
  build_ensure_init();

  compiler_begin_intercept(w);

  // The program's DEBUG (jai first.jai - DEBUG: shaders compiled unoptimized,
  // with D3D11's debug bindings) and RELEASE, given to it as constants: worked
  // out in it, by #run, they'd wait on the imports that depend on them.
  debug := false;
  for options.compile_time_command_line  if it == "DEBUG"  debug = true;
  add_build_string(tprint("DEBUG :: %;\nRELEASE :: %;\n", debug, RELEASE), w);

  for src_files  add_build_file(it, w);

  // actually compile the code, and wait for it to finish compiling
  while true {
    message := compiler_wait_for_message();
    if !message continue;
    if message.workspace != w continue;
    if message.kind == .COMPLETE break;
  }

  compiler_end_intercept(w);
}


