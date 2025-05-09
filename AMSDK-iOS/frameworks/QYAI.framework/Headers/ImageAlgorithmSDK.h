#ifndef IMAGEALGORITHMS
#define IMAGEALGORITHMS

#include <opencv2/opencv.hpp>
#include <random>

namespace ImageAlgorithmSDK {

	enum DitherLevel {
		dlNone = 0,
		dlLevel2 = 2,
		dlLevel4 = 4,
		dlLevel8 = 8,
		dlLevel16 = 16
	};
#define is_2s_pow(number)  !((number) & ((number) - 1))
#define ALGORITHM_THREAD_NUM  4
	class ImageAlgorithm {
	private:
		static void SetColorLevel(cv::Mat& image, int shadow, float midtones, int highlight, int outputshadow, int outputhighlight);
		static void AlphaBlen(cv::Mat& src1, cv::Mat src2, cv::Mat alpha);
		static void AddRandomNoise(cv::Mat& image, float strength);
		static void FSDither(cv::Mat& image, uint8_t quantization_bits, uint8_t filter_index);
		static void FloydSteinbergLevel(cv::Mat& image, int level);
	public:
		static void Dither(cv::Mat& image, DitherLevel ditherlevel, bool bvirtualDPI = false);
	};
}
#endif