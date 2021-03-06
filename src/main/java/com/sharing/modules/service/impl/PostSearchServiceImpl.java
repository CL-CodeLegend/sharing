package com.sharing.modules.service.impl;

import com.sharing.modules.aspect.PostStatusFilter;
import com.sharing.modules.data.PostVO;
import com.sharing.modules.data.UserVO;
import com.sharing.modules.entity.Post;
import com.sharing.modules.repository.PostRepository;
import com.sharing.modules.service.PostSearchService;
import com.sharing.modules.service.UserService;
import com.sharing.base.utils.BeanMapUtils;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.apache.lucene.analysis.cn.smart.SmartChineseAnalyzer;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.highlight.Highlighter;
import org.apache.lucene.search.highlight.QueryScorer;
import org.apache.lucene.search.highlight.SimpleHTMLFormatter;
import org.hibernate.search.jpa.FullTextEntityManager;
import org.hibernate.search.jpa.FullTextQuery;
import org.hibernate.search.jpa.Search;
import org.hibernate.search.query.dsl.QueryBuilder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author : wangcl
 * @version : 1.0
 * @date : 2019/1/18
 */
@Slf4j
@Service
@Transactional
public class PostSearchServiceImpl implements PostSearchService {
    @Autowired
    private EntityManager entityManager;

    @Autowired
    private UserService userService;
    @Autowired
    private PostRepository postRepository;

    @Override
    @PostStatusFilter
    public Page<PostVO> search(Pageable pageable, String term) throws Exception {
        FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
        QueryBuilder builder = fullTextEntityManager.getSearchFactory().buildQueryBuilder().forEntity(Post.class).get();

        Query luceneQuery = builder
                .keyword()
                .fuzzy()
                .withEditDistanceUpTo(1)
                .withPrefixLength(1)
                .onFields("title", "summary", "tags")
                .matching(term).createQuery();

        FullTextQuery query = fullTextEntityManager.createFullTextQuery(luceneQuery, Post.class);
        query.setFirstResult((int) pageable.getOffset());
        query.setMaxResults(pageable.getPageSize());
        SmartChineseAnalyzer analyzer = new SmartChineseAnalyzer();
        SimpleHTMLFormatter formatter = new SimpleHTMLFormatter("<span style='color:red;'>", "</span>");
        QueryScorer scorer = new QueryScorer(luceneQuery);
        Highlighter highlighter = new Highlighter(formatter, scorer);

        List<Post> list = query.getResultList();
        List<PostVO> rets = list.stream().map(po -> {
            PostVO post = BeanMapUtils.copy(po);

            try {
                // 处理高亮
                String title = highlighter.getBestFragment(analyzer, "title", post.getTitle());
                String summary = highlighter.getBestFragment(analyzer, "summary", post.getSummary());

                if (StringUtils.isNotEmpty(title)) {
                    post.setTitle(title);
                }
                if (StringUtils.isNotEmpty(summary)) {
                    post.setSummary(summary);
                }
            } catch (Exception e) {
                log.error(e.getMessage(), e);
            }
            return post;
        }).collect(Collectors.toList());
        buildUsers(rets);
        return new PageImpl<>(rets, pageable, query.getResultSize());
    }

    @Override
    public List<Object[]> relevant(String tags) {
        if (tags.length() > 1) {
            List returnList = new ArrayList();
            List mid_list = new ArrayList();
            List id_remem = new ArrayList();
            Random rand = new Random();
            List<String> tagList = Arrays.asList(tags.split(","));
            for (String tag : tagList) {
                if (tag.length() > 0) {
                    for (Object[] obj : postRepository.queryPostByTag(tag)) {
                        if (!id_remem.contains(obj[0])) {
                            mid_list.add(obj);
                            id_remem.add(obj[0]);
                        }
                    }
                }
            }
            if (mid_list.size() > 10) {
                Object obj = new Object();
                int tempIndex;
                for (int i = 0; i < 10; i++) {
                    tempIndex = rand.nextInt(mid_list.size());
                    obj = mid_list.get(tempIndex);
                    mid_list.remove(tempIndex);
                    returnList.add(obj);
                    if (mid_list.size() == 0) {
                        break;
                    }
                }
            } else {
                return mid_list;
            }
            return returnList;
        }
        return null;
    }

    @Override
    public void resetIndexes() {
        FullTextEntityManager fullTextEntityManager = Search.getFullTextEntityManager(entityManager);
        fullTextEntityManager.createIndexer(Post.class).start();
    }


    private void buildUsers(List<PostVO> list) {
        if (null == list) {
            return;
        }
        HashSet<Long> uids = new HashSet<>();
        list.forEach(n -> uids.add(n.getAuthorId()));
        Map<Long, UserVO> userMap = userService.findMapByIds(uids);
        list.forEach(p -> p.setAuthor(userMap.get(p.getAuthorId())));
    }
}
