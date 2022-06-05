#pragma once

#include <basetsd.h>

/*
쉘 정렬 간격
2, 3, 5 중 한 가지를 선택할 수 있음
*/
typedef enum {
	g_two = 2,
	g_three = 3,
	g_five = 5,
	g_seven = 7
} gap_scale;

#if defined _WIN64 && defined _WINDLL
#define LIB_CALL extern "C" __declspec(dllexport)
#elif defined _WIN64 && !defined _WINDLL
#define LIB_CALL extern "C" __declspec(dllimport)
#else
#define LIB_CALL
#endif

/*
CUDA 지원 그래픽카드 병렬 처리용 쉘 정렬 함수
data의 메모리 공간은 반드시 cudaMallocManaged 함수로 할당되어 있어야 함
e에 클럭 타입 변수의 주소를 대입하면 시간을 측정할 수 있음
*/
LIB_CALL void shell_sort(int* data, UINT32 n, gap_scale s, INT64* e = nullptr);
