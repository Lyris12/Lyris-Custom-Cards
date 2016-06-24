--真黒竜サイバー・ダークネス・ドラゴンЯ
local id,ref=GIR()
function ref.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(ref.fscon)
	e1:SetOperation(ref.fsop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010050,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(ref.eqtg)
	e2:SetOperation(ref.eqop)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010050,2))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(ref.effop)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(ref.desreptg)
	e4:SetOperation(ref.desrepop)
	c:RegisterEffect(e4)
end
function ref.brfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x5d)
end
function ref.fscon(e,g,gc,chkf)
	if g==nil then return true end
	if not gc then
		local loc1=LOCATION_SZONE
		local loc2=LOCATION_SZONE
		if not g:Filter(Card.IsControler,nil,e:GetHandlerPlayer()):IsExists(Card.IsOnField,1,nil) then loc1=0 end
		if not g:Filter(Card.IsControler,nil,1-e:GetHandlerPlayer()):IsExists(Card.IsOnField,1,nil) then loc2=0 end
		local mc=g:GetFirst()
		while mc do
			local lct=mc:GetLocation()
			local p=mc:GetControler()
			if p==e:GetHandlerPlayer() then loc1=bit.bor(loc1,lct) else loc2=bit.bor(loc2,lct) end
			mc=g:GetNext()
		end
		local sg=Duel.GetMatchingGroup(ref.brfilter,e:GetHandlerPlayer(),loc1,loc2,nil)
	end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if sg then mg:Merge(sg) end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		if (gc:IsFusionCode(40418351) or gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and mg:IsExists(ref.brfilter,1,gc) then
			return true
			elseif ref.brfilter(gc) then
			local g1=Group.CreateGroup() local g2=Group.CreateGroup()
			local tc=mg:GetFirst()
			while tc do
				if tc:IsFusionCode(40418351) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
				then g1:AddCard(tc) end
				if ref.brfilter(tc) then g2:AddCard(tc) end
				tc=mg:GetNext()
			end
			g1:RemoveCard(gc)
			return g1:GetCount()>0
		else return false end
	end
	local b1=0 local b2=0 local bw=0
	local fs=false
	local tc=mg:GetFirst()
	while tc do
		local c1=tc:IsFusionCode(40418351) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
		local c2=ref.brfilter(tc)
		if c1 or c2 then
			if aux.FConditionCheckF(tc,chkf) then fs=true end
			if c1 and c2 then bw=bw+1
				elseif c1 then b1=1
				else b2=b2+1
			end
		end
		tc=mg:GetNext()
	end
	if b2>1 then b2=1 end
	return b1+b2+bw>=2 and (fs or chkf==PLAYER_NONE)
end
function ref.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if not gc then
		local loc1=LOCATION_SZONE
		local loc2=LOCATION_SZONE
		if not eg:Filter(Card.IsControler,nil,tp):IsExists(Card.IsOnField,1,nil) then loc1=0 end
		if not eg:Filter(Card.IsControler,nil,1-tp):IsExists(Card.IsOnField,1,nil) then loc2=0 end
		local mc=eg:GetFirst()
		while mc do
			local lct=mc:GetLocation()
			local p=mc:GetControler()
			if p==e:GetHandlerPlayer() then loc1=bit.bor(loc1,lct) else loc2=bit.bor(loc2,lct) end
			mc=eg:GetNext()
		end
		local mg=Duel.GetMatchingGroup(ref.brfilter,e:GetHandlerPlayer(),loc1,loc2,nil)
	end
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if mg then g:Merge(mg) end
	if gc then
		if (gc:IsFusionCode(40418351) or gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and g:IsExists(ref.brfilter,1,gc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=g:FilterSelect(tp,ref.brfilter,1,1,gc)
			Duel.SetFusionMaterial(g1)
		else
			local sg1=Group.CreateGroup() local sg2=Group.CreateGroup()
			local tc=g:GetFirst()
			while tc do
				if tc:IsFusionCode(40418351) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then sg1:AddCard(tc) end
				if ref.brfilter(tc) then sg2:AddCard(tc) end
				tc=g:GetNext()
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=sg1:Select(tp,1,1,gc)
			Duel.SetFusionMaterial(g1)
		end
		return
	end
	local sg1=Group.CreateGroup() local sg2=Group.CreateGroup() local fs=false
	local tc=g:GetFirst()
	while tc do
		if tc:IsFusionCode(40418351) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then sg1:AddCard(tc) end
		if ref.brfilter(tc) then sg2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
		tc=g:GetNext()
	end
	if chkf~=PLAYER_NONE then
		if sg2:GetCount()==1 then
			sg1:Sub(sg2)
		end
		local g1=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		if fs then g1=sg1:Select(tp,1,1,nil)
		else g1=sg1:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf) end
		local tc1=g1:GetFirst()
		sg2:RemoveCard(tc1)
		if aux.FConditionCheckF(tc1,chkf) or sg2:GetCount()==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g2=sg2:Select(tp,1,1,tc1)
			g1:Merge(g2)
			else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g2=sg2:FilterSelect(tp,aux.FConditionCheckF,1,1,tc1,chkf)
			g1:Merge(g2)
		end
		Duel.SetFusionMaterial(g1)
		else
		if sg2:GetCount()==1 then
			sg1:Sub(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g1:Merge(sg2:Select(tp,1,1,g1:GetFirst()))
		Duel.SetFusionMaterial(g1)
	end
end
function ref.filter(c)
	return c:IsRace(RACE_DRAGON)
end
function ref.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and ref.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.IsExistingTarget(ref.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectMatchingCard(tp,ref.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,tc,1,0,0)
end
function ref.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(ref.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
function ref.eqlimit(e,c)
	return e:GetOwner()==c
end
function ref.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local wg=Duel.GetMatchingGroup(ref.filter,tp,LOCATION_SZONE,0,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:GetFlagEffect(code) then
			c:CopyEffect(code, RESET_EVENT+0x1fe0000+EVENT_CHAINING, 1)
			c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+EVENT_CHAINING,0,1)
		end
		wbc=wg:GetNext()
	end
end
function ref.repfilter(c)
	return c:IsLocation(LOCATION_SZONE) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function ref.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=c:GetEquipGroup()
		return not c:IsReason(REASON_REPLACE) and g:IsExists(ref.repfilter,1,nil)
	end
	local g=c:GetEquipGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:FilterSelect(tp,ref.repfilter,1,1,nil)
	Duel.SetTargetCard(sg)
	return true
end
function ref.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(tg,REASON_EFFECT+REASON_REPLACE)
end
