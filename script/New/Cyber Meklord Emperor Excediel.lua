--機皇帝サイバー・エクセディエル∞
function c101010029.initial_effect(c)
	--Synchro Summon
	aux.AddSynchroProcedure2(c,aux.FilterBoolFunction(c101010029.tfilter),aux.NonTuner(c101010029.tfilter))
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,101010029)
	--equip
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(101010029,1))
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1)
	e0:SetTarget(c101010029.eqtg)
	e0:SetOperation(c101010029.eqop)
	c:RegisterEffect(e0)
	--cannot be targeted
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgval)
	c:RegisterEffect(e3)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010029,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c101010029.sptg)
	e2:SetOperation(c101010029.spop)
	c:RegisterEffect(e2)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c101010029.syntg)
	e1:SetValue(1)
	e1:SetOperation(c101010029.synop)
	c:RegisterEffect(e1)
end
function c101010029.tfilter(c)
	return c:IsSetCard(0x93) or c:IsSetCard(0x13)
end
function c101010029.eqfilter(c)
	return c:IsFaceup() and c:IsType(0x1802040) and c:IsAbleToChangeControler()
end
function c101010029.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c101010029.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
	and Duel.IsExistingTarget(c101010029.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c101010029.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c101010029.eqlimit(e,c)
	return e:GetOwner()==c
end
function c101010029.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c101010029.eqlimit)
			tc:RegisterEffect(e1)
			if atk>0 then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				e2:SetValue(atk)
				tc:RegisterEffect(e2)
			end
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c101010029.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and (c:IsSetCard(0x93) or c:IsSetCard(0x13))
end
function c101010029.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c101010029.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c101010029.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010029.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummonStep(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		g:GetFirst():RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c101010029.synfilter1(c,syncard,tuner,f)
	return c:IsFaceup() and c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c101010029.synfilter2(c,syncard,tuner,f)
	return c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c))
end
function c101010029.synfilter3(c,syncard,tuner,f)
	return c:IsNotTuner() and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c)) and c:GetLevel()==lv
end
function c101010029.syntg(e,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	if lv<=0 then return false end
	local g=Duel.GetMatchingGroup(c101010029.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(c101010029.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
	g:Merge(exg)
	return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
end
-- local c=e:GetHandler()
-- local lv=syncard:GetLevel()-c:GetLevel()
-- if lv<=0 then return false end
-- local g=Duel.GetMatchingGroup(c101010029.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
-- if Duel.IsExistingMatchingCard(c101010029.synfilter3,syncard:GetControler(),LOCATION_HAND,0,1,nil,syncard,c,f,lv) then
-- local exg=Duel.GetMatchingGroup(c101010029.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
-- g:Merge(exg)
-- end
-- return g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard)
-- end
--[[ local exg=Duel.GetMatchingGroup(c101010029.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
	local exc=0
	local tc=exg:GetFirst()
	while tc do
	if tc:GetLevel()==lv then exc=exc+1 end
	tc=exg:GetNext()
	end
	return
	exc>0
else end]]
function c101010029.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,minc,maxc)
	local c=e:GetHandler()
	local lv=syncard:GetLevel()-c:GetLevel()
	local g=Duel.GetMatchingGroup(c101010029.synfilter1,syncard:GetControler(),LOCATION_MZONE,LOCATION_MZONE,c,syncard,c,f)
	local exg=Duel.GetMatchingGroup(c101010029.synfilter2,syncard:GetControler(),LOCATION_HAND,0,c,syncard,c,f)
	local tn=nil
	if exg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		tn=exg:Select(tp,1,1,nil):GetFirst()
		lv=lv-tn:GetLevel()
		if lv<0 then return end
		if lv==0 then
			g=Group.FromCards(c)
			g:AddCard(tn)
			Duel.SetSynchroMaterial(g)
			return
		end
	end
	if not g:CheckWithSumEqual(Card.GetSynchroLevel,lv,minc,maxc,syncard) then Duel.SetSynchroMaterial(Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,syncard)) return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local sg=g:SelectWithSumEqual(tp,Card.GetSynchroLevel,lv,minc,maxc,syncard)
	if tn~=nil then sg:AddCard(tn) end
	Duel.SetSynchroMaterial(sg)
end
