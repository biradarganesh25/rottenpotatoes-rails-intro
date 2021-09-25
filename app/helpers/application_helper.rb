module ApplicationHelper
    def get_table_header_class(col)
        if params['sort']!=nil && params['sort']==col
            return "hilite"
        end
        return ''
    end
    
    def get_sorted_column_header_text(col)
        if params['sort']!=nil && params['sort']==col
            return "text-success"
        else
            return ""
        end
    end

    def is_checked? (rating)
        if (params['ratings']==nil)
            return true
        end
        return params['ratings'].key? rating
    end
end
