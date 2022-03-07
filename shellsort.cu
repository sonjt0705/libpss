#include <cuda_runtime.h>
#include <device_launch_parameters.h>
#include "shellsort.h"

#define THREAD_COUNT 1024
#define THREAD_DUMMY 1023

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

void shell_sort(int* data, UINT32 n, gap_scale s, clock_t* e) {
	UINT32 bd = THREAD_COUNT;
	UINT32 gd = (n + THREAD_DUMMY) / THREAD_COUNT;
	clock_t sg = clock();
	for (UINT32 g = n / s; g > 1; g /= s) gap_shell_sort <<< gd, bd >>> (data, n, g);
	clock_t fg = clock();
	cudaDeviceSynchronize();
	int t;
	UINT32 k;
	clock_t so = clock();
	for (UINT32 j = 0; j < n; j++) {
		t = data[j];
		k = j;
		while (k > 0 && data[k - 1] > t) {
			data[k] = data[k - 1];
			k--;
		}
		data[k] = t;
	}
	clock_t fo = clock();
	if (e != nullptr) *e = (fg - sg) + (fo - so);
}
