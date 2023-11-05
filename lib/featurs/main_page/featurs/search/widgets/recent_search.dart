import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../injection.dart';
import '../../../data_source/data_source.dart';
import '../cubit/sreach_cubit.dart';

class RecentSearch extends StatelessWidget {
  final SearchCubit cubit;
  final Function(String selected) selectHistorySearch;
  RecentSearch(
      {super.key, required this.cubit, required this.selectHistorySearch}) {
    cubit.getSearchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            List<Map<String, dynamic>> searchHistory = cubit.searchHistory;
            if (state is SearchHistory) {
              searchHistory = cubit.searchHistory;
            }
            return Column(
              children: [
                SizedBox(height: searchHistory.isEmpty ? 0 : 15.h),
                searchHistory.isEmpty
                    ? const SizedBox.shrink()
                    : SizedBox(
                        width: double.infinity,
                        child: Text(
                          "Recent search",
                          style: TextStyle(
                              color: const Color(0xFF888888),
                              fontSize: 18.sp,
                              fontFamily: 'DM Sans'),
                        ),
                      ),
                SizedBox(height: 15.h),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  separatorBuilder: (context, index) => SizedBox(height: 15.h),
                  shrinkWrap: true,
                  itemCount:
                      searchHistory.length < 3 ? searchHistory.length : 3,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        selectHistorySearch(searchHistory[index]['word']);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            color: Color(0xFFF0EFEF),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            searchHistory[index]['word'],
                            style: TextStyle(
                                color: const Color(0xFF515151),
                                fontSize: 14.sp,
                                fontFamily: 'DM Sans'),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () {
                                sl
                                    .get<DataSource>()
                                    .deleteWordFormSearchHistory(
                                        searchHistory[index]['word']);
                                cubit.getSearchHistory();
                              },
                              child: const Icon(Icons.close))
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
