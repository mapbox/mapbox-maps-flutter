package com.mapbox.maps.mapbox_maps_example;

import android.Manifest.permission;
import androidx.test.rule.ActivityTestRule;
import androidx.test.rule.GrantPermissionRule;
import dev.flutter.plugins.integration_test.FlutterTestRunner;
import org.junit.Rule;
import org.junit.runner.RunWith;

@RunWith(FlutterTestRunner.class)
public class MainActivityTest {

  @Rule
  public GrantPermissionRule permissionRule =
      GrantPermissionRule.grant(permission.ACCESS_COARSE_LOCATION);

  @Rule
  public ActivityTestRule<MainActivity> rule =
      new ActivityTestRule<>(MainActivity.class, true, false);
}