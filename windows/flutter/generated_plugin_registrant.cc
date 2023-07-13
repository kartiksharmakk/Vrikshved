//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <tflite_flutter_helper/tflite_flutter_helper_plugin.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  TfliteFlutterHelperPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("TfliteFlutterHelperPlugin"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
