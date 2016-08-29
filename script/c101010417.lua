--サイバー・ダーク・エンプレス ライリスЯ
function c101010417.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c101010417.fscon)
	e0:SetOperation(c101010417.fsop)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010049,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101010417.sstg)
	e1:SetOperation(c101010417.ssop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101010417.tgtg)
	e2:SetOperation(c101010417.tgop)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010049,2))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c101010417.sumtg)
	e3:SetOperation(c101010417.sumop)
	c:RegisterEffect(e3)
	--If this card is sent to the Graveyard: Target 1 banished "Cyber Queen Lyris"; Special Summon that target in face-up Attack Position.
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c101010417.revcon)
	e4:SetTarget(c101010417.revtg)
	e4:SetOperation(c101010417.revop)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101010049,3))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c101010417.descost)
	e5:SetTarget(c101010417.destg)
	e5:SetOperation(c101010417.desop)
	c:RegisterEffect(e5)
	--equip
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetTarget(c101010417.eqtg)
	e6:SetOperation(c101010417.eqop)
	c:RegisterEffect(e6)
	--equip change
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(101010049,4))
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetCategory(CATEGORY_EQUIP)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c101010417.eqctg)
	e7:SetOperation(c101010417.eqcop)
	c:RegisterEffect(e7)
end
function c101010417.material(c)
	return c:IsSetCard(0x5d) and c:IsType(TYPE_SPELL)
end
function c101010417.fscon(e,g,gc,chkf)
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
		local sg=Duel.GetMatchingGroup(c101010417.material,e:GetHandlerPlayer(),loc1,loc2,nil)
	end
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if sg then mg:Merge(sg) end
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		if (gc:IsFusionCode(101010023) or gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and mg:IsExists(c101010417.material,1,gc) then
			return true
			elseif c101010417.material(gc) then
			local g1=Group.CreateGroup() local g2=Group.CreateGroup()
			local tc=mg:GetFirst()
			while tc do
				if tc:IsFusionCode(101010023) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
				then g1:AddCard(tc) end
				if c101010417.material(tc) then g2:AddCard(tc) end
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
		local c1=tc:IsFusionCode(101010023) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
		local c2=c101010417.material(tc)
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
function c101010417.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
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
	local mg=Duel.GetMatchingGroup(c101010417.material,e:GetHandlerPlayer(),loc1,loc2,nil)
	end
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if mg then g:Merge(mg) end
	if gc then
		if (gc:IsFusionCode(101010023) or gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) and g:IsExists(c101010417.material,1,gc) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g1=g:FilterSelect(tp,c101010417.material,1,1,gc)
			Duel.SetFusionMaterial(g1)
			else
			local sg1=Group.CreateGroup() local sg2=Group.CreateGroup()
			local tc=g:GetFirst()
			while tc do
				if tc:IsFusionCode(101010023) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then sg1:AddCard(tc) end
				if c101010417.material(tc) then sg2:AddCard(tc) end
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
		if tc:IsFusionCode(101010023) or tc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) then sg1:AddCard(tc) end
		if c101010417.material(tc) then sg2:AddCard(tc) if aux.FConditionCheckF(tc,chkf) then fs=true end end
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
function c101010417.distarget(e,c)
	return (c:IsAttribute(ATTRIBUTE_FIRE) or c:IsAttribute(ATTRIBUTE_WATER))
end
function c101010417.ssfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010417.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c101010417.ssfilter,tp,LOCATION_DECK,0,2,nil,e,tp,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c101010417.ssop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010417.ssfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp,nil)
	if g:GetCount()>1 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BP)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c101010417.tgfilter(c)
	return c:IsAbleToGrave() and (c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c101010417.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
	and Duel.IsExistingMatchingCard(c101010417.tgfilter,tp,LOCATION_DECK,0,1,c,e,tp,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(101010049,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c101010417.tgfilter,tp,LOCATION_DECK,0,1,1,c,e,tp,nil)
		e:SetLabelObject(g:GetFirst())
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g:GetFirst(),1,0,0)
		return true
	else return false end
end
function c101010417.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c101010417.nsfilter(c)
	return c:IsRace(RACE_MACHINE) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and c:IsSummonable(true,nil)
end
function c101010417.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c101010417.nsfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c101010417.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010417.nsfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c101010417.revcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsReason(REASON_RETURN)
end
function c101010417.revfilter(c,e,tp)
	return c:IsCode(101010023) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010417.revtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c101010417.revfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingTarget(c101010417.revfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101010417.revfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101010417.revop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c101010417.cfilter(c)
	return c:IsRace(RACE_MACHINE) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK))and c:IsDestructable()
end
function c101010417.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010417.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local d1=Duel.SelectMatchingCard(tp,c101010417.cfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp)
	Duel.Destroy(d1,REASON_COST)
end
function c101010417.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,0,0)
end
function c101010417.desop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,e:GetHandler())
	Duel.Destroy(dg,REASON_EFFECT,LOCATION_REMOVED)
end
function c101010417.eqfilter(c)
	return c:IsRace(RACE_DRAGON)
end
function c101010417.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101010417.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.IsExistingTarget(c101010417.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101010417.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c101010417.eqop(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetValue(c101010417.eqlimit)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(c101010417.repval)
		tc:RegisterEffect(e3)
	end
end
function c101010417.eqlimit(e,c)
	return e:GetOwner()==c
end
function c101010417.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0
end
function c101010417.cdfilter(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetCode()~=101010049
end
function c101010417.eqfilter2(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:GetEquipTarget()
end
function c101010417.eqctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c101010417.cdfilter,tp,LOCATION_MZONE,0,1,nil,nil) and Duel.IsExistingTarget(c101010417.eqfilter2,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c101010417.eqfilter2,tp,LOCATION_SZONE,0,1,1,nil,tp)
	local eqc=g1:GetFirst()
	e:SetLabelObject(eqc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c101010417.cdfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
end
function c101010417.eqcop(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==eqc then tc=g:GetNext() end
	if not tc:IsRelateToEffect(e) and tc:IsFacedown() then
		Duel.SendtoGrave(eqc,REASON_EFFECT)
		return
	end
	local atk=eqc:GetTextAttack()
	if atk<0 then atk=0 end
	if not Duel.Equip(tp,eqc,tc,false) then return end
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c101010417.eqlimit)
	eqc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(tc)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetValue(c101010417.repval)
	eqc:RegisterEffect(e2)
end
