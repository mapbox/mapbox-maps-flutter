// Autogenerated from Pigeon (v16.0.0), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package com.mapbox.maps.pigeons;

import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.CLASS;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.io.ByteArrayOutputStream;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;
import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression", "serial"})
public class FLTGestureListeners {

  /** Error class for passing custom error details to Flutter via a thrown PlatformException. */
  public static class FlutterError extends RuntimeException {

    /** The error code. */
    public final String code;

    /** The error details. Must be a datatype supported by the api codec. */
    public final Object details;

    public FlutterError(@NonNull String code, @Nullable String message, @Nullable Object details) 
    {
      super(message);
      this.code = code;
      this.details = details;
    }
  }

  @NonNull
  protected static FlutterError createConnectionError(@NonNull String channelName) {
    return new FlutterError("channel-error",  "Unable to establish connection on channel: " + channelName + ".", "");
  }

  @Target(METHOD)
  @Retention(CLASS)
  @interface CanIgnoreReturnValue {}

  /**
   * Describes the coordinate on the screen, measured from top to bottom and from left to right.
   * Note: the `map` uses screen coordinate units measured in `logical pixels`.
   *
   * Generated class from Pigeon that represents data sent in messages.
   */
  public static final class ScreenCoordinate {
    /** A value representing the x position of this coordinate. */
    private @NonNull Double x;

    public @NonNull Double getX() {
      return x;
    }

    public void setX(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"x\" is null.");
      }
      this.x = setterArg;
    }

    /** A value representing the y position of this coordinate. */
    private @NonNull Double y;

    public @NonNull Double getY() {
      return y;
    }

    public void setY(@NonNull Double setterArg) {
      if (setterArg == null) {
        throw new IllegalStateException("Nonnull field \"y\" is null.");
      }
      this.y = setterArg;
    }

    /** Constructor is non-public to enforce null safety; use Builder. */
    ScreenCoordinate() {}

    public static final class Builder {

      private @Nullable Double x;

      @CanIgnoreReturnValue
      public @NonNull Builder setX(@NonNull Double setterArg) {
        this.x = setterArg;
        return this;
      }

      private @Nullable Double y;

      @CanIgnoreReturnValue
      public @NonNull Builder setY(@NonNull Double setterArg) {
        this.y = setterArg;
        return this;
      }

      public @NonNull ScreenCoordinate build() {
        ScreenCoordinate pigeonReturn = new ScreenCoordinate();
        pigeonReturn.setX(x);
        pigeonReturn.setY(y);
        return pigeonReturn;
      }
    }

    @NonNull
    ArrayList<Object> toList() {
      ArrayList<Object> toListResult = new ArrayList<Object>(2);
      toListResult.add(x);
      toListResult.add(y);
      return toListResult;
    }

    static @NonNull ScreenCoordinate fromList(@NonNull ArrayList<Object> list) {
      ScreenCoordinate pigeonResult = new ScreenCoordinate();
      Object x = list.get(0);
      pigeonResult.setX((Double) x);
      Object y = list.get(1);
      pigeonResult.setY((Double) y);
      return pigeonResult;
    }
  }

  /** Asynchronous error handling return type for non-nullable API method returns. */
  public interface Result<T> {
    /** Success case callback method for handling returns. */
    void success(@NonNull T result);

    /** Failure case callback method for handling errors. */
    void error(@NonNull Throwable error);
  }
  /** Asynchronous error handling return type for nullable API method returns. */
  public interface NullableResult<T> {
    /** Success case callback method for handling returns. */
    void success(@Nullable T result);

    /** Failure case callback method for handling errors. */
    void error(@NonNull Throwable error);
  }
  /** Asynchronous error handling return type for void API method returns. */
  public interface VoidResult {
    /** Success case callback method for handling returns. */
    void success();

    /** Failure case callback method for handling errors. */
    void error(@NonNull Throwable error);
  }

  private static class GestureListenerCodec extends StandardMessageCodec {
    public static final GestureListenerCodec INSTANCE = new GestureListenerCodec();

    private GestureListenerCodec() {}

    @Override
    protected Object readValueOfType(byte type, @NonNull ByteBuffer buffer) {
      switch (type) {
        case (byte) 128:
          return ScreenCoordinate.fromList((ArrayList<Object>) readValue(buffer));
        default:
          return super.readValueOfType(type, buffer);
      }
    }

    @Override
    protected void writeValue(@NonNull ByteArrayOutputStream stream, Object value) {
      if (value instanceof ScreenCoordinate) {
        stream.write(128);
        writeValue(stream, ((ScreenCoordinate) value).toList());
      } else {
        super.writeValue(stream, value);
      }
    }
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class GestureListener {
    private final @NonNull BinaryMessenger binaryMessenger;

    public GestureListener(@NonNull BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    /** Public interface for sending reply. */ 
    /** The codec used by GestureListener. */
    static @NonNull MessageCodec<Object> getCodec() {
      return GestureListenerCodec.INSTANCE;
    }
    public void onTap(@NonNull ScreenCoordinate coordinateArg, @NonNull Map<String, Object> pointArg, @NonNull VoidResult result) {
      final String channelName = "dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onTap";
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, channelName, getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(coordinateArg, pointArg)),
          channelReply -> {
            if (channelReply instanceof List) {
              List<Object> listReply = (List<Object>) channelReply;
              if (listReply.size() > 1) {
                result.error(new FlutterError((String) listReply.get(0), (String) listReply.get(1), (String) listReply.get(2)));
              } else {
                result.success();
              }
            }  else {
              result.error(createConnectionError(channelName));
            } 
          });
    }
    public void onLongTap(@NonNull ScreenCoordinate coordinateArg, @NonNull Map<String, Object> pointArg, @NonNull VoidResult result) {
      final String channelName = "dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onLongTap";
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, channelName, getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(coordinateArg, pointArg)),
          channelReply -> {
            if (channelReply instanceof List) {
              List<Object> listReply = (List<Object>) channelReply;
              if (listReply.size() > 1) {
                result.error(new FlutterError((String) listReply.get(0), (String) listReply.get(1), (String) listReply.get(2)));
              } else {
                result.success();
              }
            }  else {
              result.error(createConnectionError(channelName));
            } 
          });
    }
    public void onScroll(@NonNull ScreenCoordinate coordinateArg, @NonNull Map<String, Object> pointArg, @NonNull VoidResult result) {
      final String channelName = "dev.flutter.pigeon.mapbox_maps_flutter.GestureListener.onScroll";
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, channelName, getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(coordinateArg, pointArg)),
          channelReply -> {
            if (channelReply instanceof List) {
              List<Object> listReply = (List<Object>) channelReply;
              if (listReply.size() > 1) {
                result.error(new FlutterError((String) listReply.get(0), (String) listReply.get(1), (String) listReply.get(2)));
              } else {
                result.success();
              }
            }  else {
              result.error(createConnectionError(channelName));
            } 
          });
    }
  }
}
