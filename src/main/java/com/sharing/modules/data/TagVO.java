package com.sharing.modules.data;

import com.sharing.modules.entity.Tag;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * @author : wangcl
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class TagVO extends Tag implements Serializable {
    private static final long serialVersionUID = -7787865229252467418L;

    private PostVO post;
}
