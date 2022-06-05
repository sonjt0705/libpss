#pragma once

#include <basetsd.h>

/*
�� ���� ����
2, 3, 5 �� �� ������ ������ �� ����
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
CUDA ���� �׷���ī�� ���� ó���� �� ���� �Լ�
data�� �޸� ������ �ݵ�� cudaMallocManaged �Լ��� �Ҵ�Ǿ� �־�� ��
e�� Ŭ�� Ÿ�� ������ �ּҸ� �����ϸ� �ð��� ������ �� ����
*/
LIB_CALL void shell_sort(int* data, UINT32 n, gap_scale s, INT64* e = nullptr);
