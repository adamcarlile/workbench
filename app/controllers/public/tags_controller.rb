class Public::TagsController < Public::BaseController

  def index
    add_breadcrumb 'Home', homepage_url
    add_breadcrumb 'Tags'
    find_options = {:limit => 100, :order => 'taggings_count DESC'}
    unless params[:term].blank?
      find_options[:conditions] = ['name like ?', "%#{params[:term]}%"]
    end
    @tags = Tag.with_type_scope('Page') { Tag.find(:all, find_options) }.sort_by(&:name)
    respond_to do |wants|
      wants.html {}
      wants.txt { render :text => @tags.map(&:name).join("\n") }
      wants.json { render :layout => false }
    end
  end
  
  def show
    @tag = Tag.find_by_permalink(params[:id])
    render_not_found and return unless @tag
    add_breadcrumb 'Home', homepage_url
    add_breadcrumb 'Tags', tags_path
    add_breadcrumb @tag.name
    @taggings = @tag.taggings.paginate(:all, :conditions => {:taggable_type => 'Page'}, :page => 1 )
    @taggables = @taggings.map(&:taggable)
  end

end