/**
 * @file SFXManager.h
 * @brief Sound Effects Manager untuk Rapid Texter
 * @author Alea Farrel & Team
 * @date 2025
 *
 * Mengelola pemutaran sound effects (SFX) dengan fitur toggle on/off.
 *
 * OVERLAPPING AUDIO SUPPORT:
 * - Menggunakan waveOut API dengan audio pool untuk Windows
 * - Memungkinkan multiple audio instances bermain bersamaan
 * - Zero-latency dengan pre-loaded memory buffers
 */

#ifndef SFXMANAGER_H
#define SFXMANAGER_H

#include <array>
#include <atomic>
#include <csignal>
#include <string>
#include <vector>

#ifdef _WIN32
#include <windows.h>
#include <mmsystem.h>
#endif

/**
 * @class SFXManager
 * @brief Static class untuk mengelola sound effects dengan overlapping support
 *
 * SFXManager menyediakan:
 * - Toggle SFX on/off dengan shortcut 'S'
 * - Overlapping audio playback (multiple sounds bersamaan)
 * - Pre-loaded audio buffers untuk zero latency
 *
 * Audio files yang digunakan:
 * - assets/true.wav: Dimainkan saat aksi berhasil
 * - assets/false.wav: Dimainkan saat aksi gagal/invalid
 */
class SFXManager {
public:
  /**
   * @brief Play sound untuk aksi berhasil (true.wav)
   * Supports overlapping - dapat dipanggil berkali-kali tanpa menunggu
   */
  static void playTrue();

  /**
   * @brief Play sound untuk aksi gagal (false.wav)
   * Supports overlapping - dapat dipanggil berkali-kali tanpa menunggu
   */
  static void playFalse();

  /**
   * @brief Toggle status SFX On/Off
   */
  static void toggle();

  /**
   * @brief Cek apakah SFX sedang aktif
   * @return true jika SFX enabled, false jika disabled
   */
  static bool isEnabled();

  /**
   * @brief Preload audio ke memory dan inisialisasi audio pool
   * HARUS dipanggil sebelum menggunakan playTrue/playFalse
   */
  static void preload();

  /**
   * @brief Cleanup resources saat aplikasi exit
   */
  static void cleanup();

private:
  static bool sfxEnabled;     ///< Status global SFX (default: true)
  static bool settingsLoaded; ///< Flag: settings sudah di-load dari file

#ifdef _WIN32
  // ============================================================================
  // AUDIO POOL SYSTEM (Industry Standard: Polyphonic Audio)
  // ============================================================================

  /// Jumlah audio channels dalam pool (memungkinkan N overlapping sounds)
  static constexpr int AUDIO_POOL_SIZE = 8;

  /// WAV data buffers (pre-loaded di memory)
  static std::vector<char> trueWavData;
  static std::vector<char> falseWavData;
  static std::atomic<bool> buffersLoaded;
  static std::atomic<bool> isLoading;

  /// Pre-parsed WAV format untuk zero-overhead playback
  static WAVEFORMATEX trueFormat;
  static WAVEFORMATEX falseFormat;
  static const char* trueAudioData;   ///< Pointer ke audio data dalam trueWavData
  static const char* falseAudioData;  ///< Pointer ke audio data dalam falseWavData
  static DWORD trueAudioSize;
  static DWORD falseAudioSize;

  /// Audio output devices pool (pre-initialized)
  static std::array<HWAVEOUT, AUDIO_POOL_SIZE> waveOutHandles;
  static std::array<WAVEHDR, AUDIO_POOL_SIZE> waveHeaders;
  static std::array<std::atomic<bool>, AUDIO_POOL_SIZE> channelBusy;
  static std::atomic<int> nextChannel;
  static std::atomic<bool> handlesInitialized;  ///< Flag: handles sudah dibuka

  /**
   * @brief Load WAV file ke memory buffer
   */
  static bool loadWavFile(const char *filename, std::vector<char> &buffer);

  /**
   * @brief Parse WAV header dan ekstrak format + audio data pointer
   */
  static bool parseWavHeader(const std::vector<char> &wavData,
                             WAVEFORMATEX &format, const char*& audioData, DWORD &audioSize);

  /**
   * @brief Pre-initialize semua waveOut handles (dipanggil sekali di preload)
   */
  static void initializeHandles(const WAVEFORMATEX &format);

  /**
   * @brief Play audio dari buffer menggunakan available channel dari pool (optimized)
   * @param audioData Pointer ke audio data
   * @param audioSize Ukuran audio data dalam bytes
   */
  static void playFromPoolFast(const char* audioData, DWORD audioSize);

  /**
   * @brief Play audio dari buffer menggunakan available channel dari pool (legacy)
   */
  static void playFromPool(const std::vector<char> &wavData);

  /**
   * @brief Callback saat audio selesai diputar
   */
  static void CALLBACK waveOutCallback(HWAVEOUT hwo, UINT uMsg,
                                       DWORD_PTR dwInstance, DWORD_PTR dwParam1,
                                       DWORD_PTR dwParam2);
#else
  // Linux: SDL2_mixer audio pool (mirrors Windows waveOut approach)
  static std::atomic<bool> sdlInitialized;
  static std::atomic<bool> buffersLoaded;

  // Pre-loaded audio chunks (use void* to avoid SDL header in .h)
  static void *trueChunk;
  static void *falseChunk;

  static bool initSDL();
  static void playChunk(void *chunk);
#endif
};

#endif // SFXMANAGER_H