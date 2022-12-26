#include <stdio.h>
#include "/usr/local/cuda-12.0/targets/x86_64-linux/include/nvml.h"

int main(void) {
  // Initialize NVML
  nvmlReturn_t result = nvmlInit();
  if (result != NVML_SUCCESS) {
    printf("Failed to initialize NVML: %s\n", nvmlErrorString(result));
    return 1;
  }

  // Retrieve the number of devices
  unsigned int device_count;
  result = nvmlDeviceGetCount(&device_count);
  if (result != NVML_SUCCESS) {
    printf("Failed to retrieve device count: %s\n", nvmlErrorString(result));
    nvmlShutdown();
    return 1;
  }

  // Iterate over each device
  for (unsigned int i = 0; i < device_count; i++) {
    nvmlDevice_t device;

    // Retrieve the device handle
    result = nvmlDeviceGetHandleByIndex(i, &device);
    if (result != NVML_SUCCESS) {
      printf("Failed to retrieve device handle: %s\n", nvmlErrorString(result));
      continue;
    }

    // Retrieve the device temperature
    unsigned int temperature;
    result = nvmlDeviceGetTemperature(device, NVML_TEMPERATURE_GPU, &temperature);
    if (result != NVML_SUCCESS) {
    printf("Failed to retrieve device temperature: %s\n", nvmlErrorString(result));
    continue;
    }

    // Print the temperature
    printf("Device %d Temperature %d C \n", i, temperature);
  }

  // Shutdown NVML
  nvmlShutdown();

  return 0;
}
