import 'package:floor/floor.dart';
import '../models/store_profile_model.dart';

@dao
abstract class StoreProfileDao {
  @Query('SELECT * FROM store_profile WHERE id = 1')
  Future<StoreProfileModel?> getStoreProfile();

  @insert
  Future<void> insertStoreProfile(StoreProfileModel profile);

  @update
  Future<void> updateStoreProfile(StoreProfileModel profile);
}
