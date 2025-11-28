pragma Singleton

import Quickshell
import Quickshell.Services.Pipewire

Singleton {
  id: root

  PwObjectTracker {
    objects: [ Pipewire.defaultAudioSink, Pipewire.defaultAudioSource ]
  }

  property bool sinkMuted: Pipewire.defaultAudioSink.audio.muted
  property real sinkVolume: Math.round(Pipewire.defaultAudioSink.audio.volume * 100)
  property string sinkIcon: {
    if (sinkMuted) {
      return "volume_mute";
    }
    if (sinkVolume >= 60) {
      return "volume_up";
    }
    if (sinkVolume > 0) {
      return "volume_down";
    }
    return "volume_off";
  }

  function toggleSinkMute() {
    Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_SINK@", "toggle"]);
  }

  function setSinkVolume(volume: real) {
    Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_SINK@", volume]);
  }

  property bool sourceMuted: Pipewire.defaultAudioSource.audio.muted
  property string sourceIcon: {
    if (!sourceMuted) {
      return "mic_off";
    }
    return "mic";
  }

  function toggleSourceMute() {
    Quickshell.execDetached(["wpctl", "set-mute", "@DEFAULT_SOURCE@", "toggle"]);
  }

  function setSourceVolume(volume: real) {
    Quickshell.execDetached(["wpctl", "set-volume", "@DEFAULT_SOURCE@", volume]);
  }
}

