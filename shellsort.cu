#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include "shellsort.h"
#include <chrono>

#define THREAD_COUNT 1024
#define THREAD_DUMMY 1023

using namespace std::chrono;

__global__ void gap_shell_sort(int* data, UINT32 n, UINT32 g) {
	UINT32 i = blockIdx.x * blockDim.x + threadIdx.x;
	int t;
	UINT32 k;
	if (i >= g) return;
	for (UINT32 j = i; j < n; j += g) {
		t = data[j];
		k = j;
		while (k > g - 1 && data[k - g] > t) {
			data[k] = data[k - g];
			k -= g;
		}
		data[k] = t;
	}
}

void shell_sort(int* data, UINT32 n, gap_scale s, INT64* e) {
	UINT32 bd = THREAD_COUNT;
	UINT32 gd = (n + THREAD_DUMMY) / THREAD_COUNT;
	system_clock::time_point sg = system_clock::now();
	for (UINT32 g = n / s; g > 1; g /= s) gap_shell_sort <<< gd, bd >>> (data, n, g);
	system_clock::time_point fg = system_clock::now();
	cudaDeviceSynchronize();
	int t;
	UINT32 k;
	system_clock::time_point so = system_clock::now();
	for (UINT32 j = 0; j < n; j++) {
		t = data[j];
		k = j;
		while (k > 0 && data[k - 1] > t) {
			data[k] = data[k - 1];
			k--;
		}
		data[k] = t;
	}
	system_clock::time_point fo = system_clock::now();
	if (e != nullptr) *e = duration_cast<microseconds>(fg - sg).count() + duration_cast<microseconds>(fo - so).count();
}
