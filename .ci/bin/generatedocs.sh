#!/bin/bash

GIT_REF=${GIT_REF:-develop}

# script to auto-generate terraform documentation

# pandoc -v &> /dev/null || { echo >&2 "ERROR: Pandoc not installed" ; exit 1 ; }
terraform-docs --version &> /dev/null || { echo >&2 "ERROR: terraform-docs not installed" ; exit 1 ; }

IFS=$'\n'
# create an array of all unique directories containing .tf files 
arr=($(find . -name '*.tf' | xargs -I % sh -c 'dirname %' | sort -u))
unset IFS

for i in "${arr[@]}"
do
    # check for _docs folder
    docs_dir=$i/_docs
    echo $docs_dir
    if [[ -d "$docs_dir" ]]; then

        if ! test -f $docs_dir/README.md; then 
            echo "ERROR: _docs dir found with no README.md"; exit 1
        fi

        # generate the tf documentation
        echo "generating docs for: $i"
        .ci/bin/terraform-docs.sh markdown $i > $docs_dir/TF_MODULE.md
        INPUT_OUTPUT=$(.ci/bin/terraform-docs.sh markdown $i | sed -e 's/ /\'$'\n/g')

        # merge the tf docs with the main readme
        # pandoc --wrap=none -f gfm -t gfm $docs_dir/README.md -A $docs_dir/TF_MODULE.md > $i/README.md
       # sed -e '/___TF_INPUT_OUTPUT_VARS___/ {' -e 'r $docs_dir/TF_MODULE.md' -e 'd' -e '}' -i $i/README.md
        # cp $docs_dir/README.md $i/README.md
        # sed -i '' '/___TF_INPUT_OUTPUT_VARS___/ {' -e 'r $docs_dir/TF_MODULE.md' -e 'd' -e '}' $i/README.md
        # sed -i -e '/___TF_INPUT_OUTPUT_VARS___/{r $docs_dir/TF_MODULE.md' -e 'd}' $i/README.md
        # sed -e "/___TF_INPUT_OUTPUT_VARS___/r $docs_dir/TF_MODULE.md" -e "/___TF_INPUT_OUTPUT_VARS___/d" $i/README.md

        #sed "s/___TF_INPUT_OUTPUT_VARS___/${INPUT_OUTPUT}/g" $docs_dir/README.md
        PATTERN=___TF_INPUT_OUTPUT_VARS___ \
            .ci/bin/var-replace.awk \
            $docs_dir/README.md \
            $docs_dir/TF_MODULE.md

        # # Create a absolute link for terraform registry
        # sed -i ".bak" -e "s|__GIT_REF__|${GIT_REF}|" $i/README.md
        # rm -rf $i/README.md.bak

        # do some cleanup
        # because sed on macOS is special..
        # if [[ "$OSTYPE" == "darwin"* ]]; then
        #     sed -i '' '/<!-- end list -->/d' $i/README.md  # quirk of pandoc
        # else
        #     sed -i -e '/<!-- end list -->/d' $i/README.md  # quirk of pandoc
        # fi

    elif [[ ! -d "$docs_dir" && $i != *".terraform"* ]]; then
        # .ci/bin/terraform-docs.sh markdown $i > $i/README.md
        echo test
    fi
done
