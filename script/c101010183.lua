--created & coded by Lyris
--Sea Scout - Relic Trainee
function c101010183.initial_effect(c)
--Synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010183,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c101010183.spcost)
	e3:SetTarget(c101010183.sptg)
	e3:SetOperation(c101010183.spop)
	c:RegisterEffect(e3)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c101010183.tg)
	e1:SetOperation(c101010183.lvop)
	c:RegisterEffect(e1)
	--limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c101010183.sfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c101010183.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsType,0,LOCATION_GRAVE,LOCATION_GRAVE,nil,TYPE_SYNCHRO)
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(2081)==0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(aux.Stringid(71921856,0))
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetValue(SUMMON_TYPE_SYNCHRO)
			e1:SetCondition(c101010183.syncon)
			e1:SetOperation(c101010183.synop)
			e1:SetLabelObject(tck)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			tc:RegisterFlagEffect(2081,RESET_EVENT+EVENT_ADJUST,0,1)	
		end
		tc=g:GetNext()
	end
end
function c101010183.syncon(e,c,smat,mg)
	if c==nil then return true end
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local tuner=Duel.GetMatchingGroup(c101010183.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local nontuner=Duel.GetMatchingGroup(c101010183.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	if not mt.sync then return false end
	if c:IsSetCard(0x301) then
		return nontuner:IsExists(c101010183.lvfilter2,1,nil,c,tuner)
	else
		return tuner:IsExists(c101010183.lvfilter,1,nil,c,nontuner)
	end
end
function c101010183.lvfilter(c,syncard,nontuner)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	local lv=c:GetSynchroLevel(syncard)
	local slv=syncard:GetLevel()
	local nt=nontuner:Filter(Card.IsCanBeSynchroMaterial,nil,syncard,c)
	return mt.minntct and mt.maxntct and slv-lv>0 and nt:CheckWithSumEqual(Card.GetSynchroLevel,slv-lv,mt.minntct,mt.maxntct,syncard)
end
function c101010183.lvfilter2(c,syncard,tuner)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	local lv=c:GetSynchroLevel(syncard)
	local slv=syncard:GetLevel()
	local nt=tuner:Filter(Card.IsCanBeSynchroMaterial,nil,syncard,c)
	return mt.minntct and mt.maxntct and lv+slv>0 and nt:CheckWithSumEqual(Card.GetSynchroLevel,lv+slv,mt.minntct,mt.maxntct,syncard)
end
function c101010183.matfilter1(c,syncard)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	return c:IsType(TYPE_TUNER) and c:IsHasEffect(511002081) and c:IsCanBeSynchroMaterial(syncard) and c:IsAbleToGrave() 
		and mt.tuner_filter and mt.tuner_filter(c)
end
function c101010183.matfilter2(c,syncard)
	local code=syncard:GetOriginalCode()
	local mt=_G["c" .. code]
	return c:IsCanBeSynchroMaterial(syncard) and c:IsAbleToGrave()
		and mt.nontuner_filter and mt.nontuner_filter(c)
end
function c101010183.dtfilter1(c,syncard,lv,g1,g2,g3,g4)
	if not syncard.synfilter1 then return false end
	return syncard.synfilter1(c,syncard,lv,g1,g2,g3,g4)
end
function c101010183.dtfilter2(c,syncard,lv,g2,g4,f1,tuner1)
	if not syncard.synfilter2 then return false end
	return syncard.synfilter2(c,syncard,lv,g2,g4,f1,tuner1)
end
function c101010183.dtfilter3(c,syncard,lv,f1,f2)
	if not syncard.synfilter3 then return false end
	return syncard.synfilter3(c,syncard,lv,f1,f2)
end
function c101010183.synop(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	local tuner=Duel.GetMatchingGroup(c101010183.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local nontuner=Duel.GetMatchingGroup(c101010183.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local htuner=Duel.GetMatchingGroup(c101010183.matfilter1,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	local hnontuner=Duel.GetMatchingGroup(c101010183.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	local mat1
	if c:IsSetCard(0x301) then
		nontuner=nontuner:Filter(c101010183.lvfilter2,nil,c,tuner)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		mat1=nontuner:Select(tp,1,1,nil)
		local tlv=mat1:GetFirst():GetSynchroLevel(c)
		tuner=tuner:Filter(Card.IsCanBeSynchroMaterial,nil,c,mat1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mat2=tuner:SelectWithSumEqual(tp,Card.GetSynchroLevel,c:GetLevel()+tlv,mt.minntct,mt.maxntct,c)
		mat1:Merge(mat2)
	elseif mt.dobtun then
		mat1=Group.CreateGroup()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local t1=tuner:FilterSelect(tp,c101010183.dtfilter1,1,1,nil,c,c:GetLevel(),tuner,nontuner,htuner,hnontuner)
		tuner1=t1:GetFirst()
		mat1:AddCard(tuner1)
		nontuner:RemoveCard(tuner1)
		local lv1=tuner1:GetSynchroLevel(c)
		local f1=tuner1.tuner_filter
		local t2=nil
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		t2=tuner:FilterSelect(tp,c101010183.dtfilter2,1,1,tuner1,c,c:GetLevel()-lv1,nontuner,hnontuner,f1,tuner1)
		local tuner2=t2:GetFirst()
		mat1:AddCard(tuner2)
		nontuner:RemoveCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local f2=tuner2.tuner_filter
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=nil
		if c.dtmlt then m3=nontuner:SelectWithSumEqual(tp,Card.GetSynchroLevel,c:GetLevel()-lv1-lv2,1,99,c)
		else m3=nontuner:FilterSelect(tp,c101010183.dtfilter3,1,1,nil,c,c:GetLevel()-lv1-lv2,f1,f2) end
		mat1:Merge(m3)
	else
		tuner=tuner:Filter(c101010183.lvfilter,nil,c,nontuner)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		mat1=tuner:Select(tp,1,1,nil)
		local tlv=mat1:GetFirst():GetSynchroLevel(c)
		nontuner=nontuner:Filter(Card.IsCanBeSynchroMaterial,nil,c,mat1:GetFirst())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mat2=nontuner:SelectWithSumEqual(tp,Card.GetSynchroLevel,c:GetLevel()-tlv,mt.minntct,mt.maxntct,c)
		mat1:Merge(mat2)
	end
	c:SetMaterial(mat1)
	Duel.SendtoGrave(mat1,REASON_MATERIAL+REASON_SYNCHRO)
end
function c101010183.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,6 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101010183,1))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c101010183.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c101010183.cfilter(c,ck)
	return c:IsAbleToGraveAsCost() and c:IsLevelAbove(1)
end
function c101010183.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c101010183.cfilter,tp,LOCATION_MZONE,0,c)
	if chk==0 then return c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c101010183.sptgfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel(),mg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101010183.spfil1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	local sc=g:GetFirst()
	e:SetLabelObject(sc)
	local lv=c:GetLevel()
	local g1=Group.FromCards(c)
	local tglv=sc:GetLevel()
	while lv<tglv do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g2=mg:FilterSelect(tp,c101010183.spfil2,1,1,nil,tglv-lv,mg,sc)
			local gc=g2:GetFirst()
			lv=lv+gc:GetLevel()
			mg:RemoveCard(gc)
			g1:AddCard(gc)
	end
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c101010183.sptgfil(c,e,tp,lv,mg)
	return c:IsSetCard(0x5cd) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and mg:CheckWithSumEqual(Card.GetOriginalLevel,c:GetLevel()-lv,1,63,c) and c:IsCanBeEffectTarget(e)
end
function c101010183.spfil1(c,e,tp,tc)
	if c:IsSetCard(0x5cd) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e) then
		local mg=Duel.GetMatchingGroup(c101010183.cfilter,tp,LOCATION_MZONE,0,tc)
		return mg:IsExists(c101010183.spfil2,1,nil,c:GetLevel()-tc:GetLevel(),mg,c)
	else
		return false
	end
end
function c101010183.spfil2(c,limlv,mg,sc)
	local fg=mg:Clone()
	fg:RemoveCard(c)
	local newlim=limlv-c:GetLevel()
	if newlim==0 then return true else return fg:CheckWithSumEqual(Card.GetOriginalLevel,newlim,1,63,sc) end
end
function c101010183.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local sc=e:GetLabelObject()
	Duel.SetTargetCard(sc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sc,1,0,0)
end
function c101010183.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
